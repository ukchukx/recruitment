defmodule RecruitmentWeb.PageController do
  use RecruitmentWeb, :controller
  require Logger

  alias Recruitment.Recruit

  @base_assigns %{
    js: [], 
    scripts: ["/js/validateForms.js"], 
    message: "",
    loginErrorMessage: nil,
    signupErrorMessage: nil
  }

  plug RecruitmentWeb.Plug.EnsureAuthenticated when action not in [:index, :login_signup, :logout, :print_ref, :print_referee]

  def index(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        render conn, "index.html", @base_assigns

      _ -> 
        redirect conn, to: page_path(conn, :positions)
    end
  end

  def info(conn, _) do
    render conn, "info.html", @base_assigns
  end

  def login_signup(conn, %{"form" => form_type} = params) do
    case form_type do
      "signup" ->
        case params["g-recaptcha-response"] do
          nil ->
            assigns = 
              @base_assigns 
              |> Map.put(:signupErrorMessage, "You are not Human!")

            render conn, "index.html", assigns

          "" ->
            assigns = 
              @base_assigns 
              |> Map.put(:signupErrorMessage, "You are not Human!")
              
            render conn, "index.html", assigns

          _ ->
            fname = params["fname"]
            sname = params["sname"]
            email = params["email"]
            password = params["password"]

            case password != params["re_password"] do
              true ->
                assigns = 
                  @base_assigns 
                  |> Map.put(:signupErrorMessage, "Passwords are not the same!")
                  
                render conn, "index.html", assigns

              false ->
                case Recruit.email_exists(email) do
                  true ->
                    assigns = 
                      @base_assigns 
                      |> Map.put(:signupErrorMessage, "Email already used! Use the Login area to login.")

                    render conn, "index.html", assigns

                  false ->
                    case Recruit.create_recruit(%{fname: fname, sname: sname, email: email, password: password}) do
                      {:ok , _} -> 
                        case Recruit.signin_with_email_and_password(conn, email, password) do
                          {:ok, conn} ->
                            redirect conn, to: page_path(conn, :positions)

                          {:error, reason, conn} ->
                            Logger.error "Could not login after signup because of #{inspect reason}"

                            assigns = Map.put(@base_assigns, :signupErrorMessage, "Could not login")
                            render conn, "index.html", assigns
                        end

                      {:error, err} ->
                        Logger.error "Signup error: #{inspect err}"
                        render conn, "index.html", @base_assigns
                    end
                end                
            end            
        end

      "login" ->
        case params["g-recaptcha-response"] do
          nil ->
            assigns = 
              @base_assigns 
              |> Map.put(:loginErrorMessage, "You are not Human!")

            render conn, "index.html", assigns

          "" ->
            assigns = 
              @base_assigns 
              |> Map.put(:loginErrorMessage, "You are not Human!")
              
            render conn, "index.html", assigns

          _ ->
            email = params["email"]
            password = params["password"]
            
            case Recruit.signin_with_email_and_password(conn, email, password) do
              {:ok, %{assigns: %{current_user: %{completed: completed}}} = conn} ->
                case completed do
                  1 -> redirect conn, to: page_path(conn, :done)
                  _ -> redirect conn, to: page_path(conn, :positions)
                end

              {:error, reason, conn} ->
                Logger.error "Could not login because of #{inspect reason}"

                assigns = Map.put(@base_assigns, :loginErrorMessage, "Invalid email or password")
                render conn, "index.html", assigns
            end
        end
    end
  end

  def logout(conn, _) do
    conn
    |> Recruit.signout
    |> redirect(to: page_path(conn, :index))
  end

  def positions(%{assigns: %{current_user: current_user}} = conn, _params) do
    js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
    assigns = 
      %{@base_assigns | js: js}
      |> Map.put(:current_user, current_user)
      |> Map.put(:msg, nil)

    render conn, "positions.html", assigns
  end

  def positions_post(%{assigns: %{current_user: current_user}} = conn, params) do
    case params["position_applied_for"] do
      nil ->
        js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
        assigns = 
          %{@base_assigns | js: js}
          |> Map.put(:msg, "Please select position")
          |> Map.put(:user_id, current_user.id)

        render conn, "positions.html", assigns

      paf -> 
        case Recruit.update_recruit(current_user, %{
          application_stage: String.trim(params["application_stage"]),
          position_category: String.trim(params["position_category"]),
          position_applied_for: paf}) do
          {:ok, _} -> :ok    
          {:error, err} ->
          Logger.error "Update recruit position and application_stage returned #{inspect err}"    
        end
        redirect conn, to: page_path(conn, :registration) 
    end
  end

  def registration_post(%{assigns: %{current_user: current_user}} = conn, params) do
    current_user = Recruit.load_personal_details(current_user)
    case current_user.personal_detail do
      nil -> 
        params = Map.put(params, "recruit_id", current_user.id)

        case Recruit.create_personal_detail(params) do
          {:ok, _} ->
            case Recruit.update_recruit(current_user, %{application_stage: String.trim(params["application_stage"])}) do
              {:ok, _} -> :ok
              {:error, err} ->
                Logger.error "Update application_stage #{inspect err}"
            end
            redirect conn, to: page_path(conn, :qualifications) 

          {:error, err} ->
            Logger.error "Error creating personal_detail: #{inspect err}"
            redirect conn, to: page_path(conn, :registration) 
        end
      _ ->   
        case Recruit.update_personal_detail(current_user.personal_detail, params) do
          {:ok, _} ->
            case Recruit.update_recruit(current_user, %{application_stage: String.trim(params["application_stage"])}) do
              {:ok, _} -> :ok
              {:error, err} ->
                Logger.error "Update application_stage #{inspect err}"
            end
            redirect conn, to: page_path(conn, :qualifications) 

          {:error, err} ->
            Logger.error "Error updating personal_detail: #{inspect err}"
            redirect conn, to: page_path(conn, :registration) 
        end
    end
  end

  def registration(%{assigns: %{current_user: current_user}} = conn, _params) do
    case current_user.application_stage < 2 do
      true -> 
        redirect conn, to: page_path(conn, :positions) 

      false ->  
        current_user = Recruit.load_personal_details(current_user)
        countries = Recruit.list_countries() |> Enum.map(&Recruit.as_map/1)
        lgas = Recruit.list_lgas()|> Enum.map(&Recruit.as_map/1)
        states = Enum.reduce(lgas, [], fn (%{state: state}, acc) -> 
          if state in acc do
            acc
          else
            [state] ++ acc
          end
        end)

        curState = 
          case current_user.personal_detail do
            nil -> "Abia"
            %{curState: curState} -> curState || "Abia"
          end

        permState = 
          case current_user.personal_detail do
            nil -> "Abia"
            %{permState: permState} -> permState || "Abia"
          end
        curLgas = Enum.filter(lgas, fn %{state: state} -> state == curState end)
        permLgas = Enum.filter(lgas, fn %{state: state} -> state == permState end)

        current_user = 
          case current_user.personal_detail do
            nil ->
              pd = %{
                recruit_id: current_user.id,
                curAddress: "",
                curLga: "",
                curState: "",
                curStreet: "",
                dob: "",
                gender: "",
                height: "",
                mname: "",
                nationality: "",
                nin: "",
                permAddress: "",
                permLga: "",
                permState: "",
                permStreet: "",
                phone: "",
                age: 0,
                prefAddress: "",
                stage: 0,
                status: 0,
                title: ""
              }
              %{current_user | personal_detail: pd}

            _ -> current_user 
          end


        js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
        assigns = 
          %{@base_assigns | js: js}
          |> Map.put(:current_user, current_user)
          |> Map.put(:countries, countries)
          |> Map.put(:states, states)
          |> Map.put(:lgas, lgas)
          |> Map.put(:curLgas, curLgas)
          |> Map.put(:permLgas, permLgas)
          |> Map.put(:curState, curState)
          |> Map.put(:permState, permState)

        render conn, "registration.html", assigns
    end
  end

  def qualifications(%{assigns: %{current_user: current_user}} = conn, _params) do
    case current_user.application_stage < 3 do
      true -> 
        redirect conn, to: page_path(conn, :positions) 

      false ->  
        current_user = 
          current_user
          |> Recruit.load_personal_details
          |> Recruit.load_educational_qualifications
          |> Recruit.load_professional_qualifications

        countries = Recruit.list_countries()

        js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
        assigns = 
          %{@base_assigns | js: js}
          |> Map.put(:current_user, current_user)
          |> Map.put(:countries, countries)

        render conn, "qualifications.html", assigns
    end
  end

  def qualifications_post(%{assigns: %{current_user: current_user}} = conn, %{"form" => form} = params) do
    params = Map.put(params, "recruit_id", current_user.id)
    case form do
      "next" ->
        case Recruit.update_recruit(current_user, %{application_stage: String.trim(params["application_stage"])}) do
          {:ok, _} -> :ok
          {:error, err} ->
            Logger.error "Update application_stage #{inspect err}"
        end
        redirect conn, to: page_path(conn, :experience) 
      "back" ->
        redirect conn, to: page_path(conn, :registration) 
      "professional" ->
        Recruit.create_professional_qualification(params)
        redirect conn, to: page_path(conn, :qualifications) 
      "educational" ->
        params =
          case params["course_of_study"] do
            nil -> 
              Map.put(params, "course_of_study", params["type"])
            "" -> 
              Map.put(params, "course_of_study", params["type"])
            _ -> params  
          end

        params =
          case params["qualification"] do
            nil -> 
              Map.put(params, "qualification", params["classification"])
            "" -> 
              Map.put(params, "qualification", params["classification"])
            _ -> params  
          end

        Recruit.create_educational_qualification(params)
        redirect conn, to: page_path(conn, :qualifications) 
      "delete_professional" ->
        current_user = Recruit.load_professional_qualifications(current_user)
        id = params["id"]
        
        current_user.professional_qualifications
        |> Enum.find(fn 
          %{id: ^id} -> true  
          _ -> false  
          end)
        |> case do
          nil -> :ok
          prof -> Recruit.delete_professional_qualification(prof)
        end

        redirect conn, to: page_path(conn, :qualifications) 
      "delete_educational" ->
        current_user = Recruit.load_educational_qualifications(current_user)
        id = params["id"]
        
        current_user.educational_qualifications
        |> Enum.find(fn 
          %{id: ^id} -> true  
          _ -> false  
          end)
        |> case do
          nil -> :ok
          edu -> Recruit.delete_educational_qualification(edu)
        end
        redirect conn, to: page_path(conn, :qualifications) 
    end
  end

  def experience(%{assigns: %{current_user: current_user}} = conn, _params) do
    case current_user.application_stage < 4 do
      true -> 
        redirect conn, to: page_path(conn, :positions) 

      false ->  
        current_user = Recruit.load_work_experience(current_user)
        assigns = Map.put(@base_assigns, :current_user, current_user)

        render conn, "experience.html", assigns
    end
  end

  def experience_post(%{assigns: %{current_user: current_user}} = conn, %{"form" => form} = params) do
    params = Map.put(params, "recruit_id", current_user.id)
    case form do
      "next" ->
        case Recruit.update_recruit(current_user, %{application_stage: String.trim(params["application_stage"])}) do
          {:ok, _} -> :ok
          {:error, err} ->
            Logger.error "Update application_stage #{inspect err}"
        end
        redirect conn, to: page_path(conn, :attachments)
      "back" ->
        redirect conn, to: page_path(conn, :qualifications) 
      "experience" ->
        Recruit.create_work_experience(params)
        redirect conn, to: page_path(conn, :experience)
      "delete_experience" ->
        current_user = Recruit.load_work_experience(current_user)
        id = params["id"] |> String.trim |> String.to_integer
        
        current_user.work_experience
        |> Enum.find(fn 
          %{id: ^id} -> true  
          _ -> false  
          end)
        |> case do
          nil -> :ok
          exp -> Recruit.delete_work_experience(exp)
        end

        redirect conn, to: page_path(conn, :experience) 
    end
  end

  def attachments(%{assigns: %{current_user: current_user}} = conn, _params) do
    case current_user.application_stage < 5 do
      true -> 
        redirect conn, to: page_path(conn, :positions) 

      false ->  
        render conn, "attachments.html", get_attachment_assigns(current_user)
    end
  end

  defp get_attachment_assigns(current_user) do
    current_user = Recruit.load_attachments(current_user)
    attachments_list = Recruit.list_attachments_list()
    # position = Recruit.load_chosen_position(current_user.position_applied_for)

    js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
    assigns = 
      %{@base_assigns | js: js}
      |> Map.put(:current_user, current_user)
      |> Map.put(:attachments_list, attachments_list)
      # |> Map.put(:position, position)
      |> Map.put(:passport_uploaded, false)
      |> Map.put(:ssce_uploaded, false)
      |> Map.put(:medical_cert, false)
      |> Map.put(:cert_of_identity, false)
      |> Map.put(:birth_cert, false)
      |> Map.put(:fslc, false)
      |> Map.put(:err_msg, nil)

    assigns =
      current_user.attachments
      |> Enum.reduce(assigns, fn (%{title: title}, acc) ->  
        case title do
          "Passport Photograph" ->
            %{acc | passport_uploaded: true}

          "Medical Fitness Certificate" ->
            %{acc | medical_cert: true}

          "First School Leaving Certificate" ->
            %{acc | fslc: true}
            
          "Certificate of Identification/Origin" ->
            %{acc | cert_of_identity: true}
            
          "Birth Certificate/Age Declaration" ->
            %{acc | birth_cert: true}
            
          x ->
            case String.contains?(x, "SSCE") do
              true -> %{acc | ssce_uploaded: true}
              false -> acc
            end
        end
      end)

    files_attached =
      current_user.attachments
      |> length
      |> Kernel.>=(5)
      |> Kernel.&&(assigns.passport_uploaded)
      |> Kernel.&&(assigns.ssce_uploaded)
      |> Kernel.&&(assigns.medical_cert)
      |> Kernel.&&(assigns.cert_of_identity)
      |> Kernel.&&(assigns.birth_cert)
      |> Kernel.&&(assigns.fslc)

    Map.put(assigns, :files_attached, files_attached)
  end

  @acceptable_types [
    "application/pdf",
    "application/msword", # .doc
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document", # .docx
    "image/jpeg",
    "image/jpg",
    "image/png"]
  @file_store "/var/www/html/nps/prison_cms_files"

  def attachments_post(%{assigns: %{current_user: current_user}} = conn, %{"form" => form} = params) do
    params = Map.put(params, "recruit_id", current_user.id)

    case form do
      "next" ->
        case Recruit.set_complete(current_user) do
          {:ok, _} -> :ok
          {:error, err} ->
            Logger.error "set_complete #{inspect err}"
        end
        redirect conn, to: page_path(conn, :done)

      "back" ->
        redirect conn, to: page_path(conn, :experience) 

      "attachment" ->
        %{filename: file_name, path: f_path, content_type: ctype} = params["file"]
        file_name = String.downcase(file_name)

        assigns = 
          case ctype in @acceptable_types do
            true ->
              
              file_type = 
                file_name
                |> String.split(".")
                |> List.last

              random_number = :rand.uniform(999999)
              file_name = "#{current_user.id}_#{random_number}_#{file_name}"

              case File.cp(f_path, "#{@file_store}/#{file_name}") do
                :ok ->
                  attrs = %{title: String.trim(params["title"]), path: file_name, file_type: file_type, recruit_id: current_user.id}
                  case Recruit.create_attachment(attrs) do
                    {:ok, _} -> :ok
                    {:error, err} -> Logger.error "Attachment creation returned #{inspect err}"  
                  end
                {:error, err} -> Logger.error "File copy returned #{inspect err}"
              end

              get_attachment_assigns(current_user)
            false ->  
              current_user
              |> get_attachment_assigns
              |> Map.put(:err_msg, "Only PDF, JPG, PNG and Word files are accepted.")
          end

        render conn, "attachments.html", assigns 

      "delete_attachment" ->
        current_user = Recruit.load_attachments(current_user)
        id = params["id"] |> String.trim |> String.to_integer
        
        current_user.attachments
        |> Enum.find(fn 
          %{id: ^id} -> true
          _ -> false  
          end)
        |> case do
          nil -> :ok
          %{path: path} = att -> 
            case File.rm("#{@file_store}/#{path}") do
              {:error, err} -> Logger.error "File(#{path}) deletion failed with #{inspect err}"
              x -> x 
            end

            Recruit.delete_attachment(att)
            redirect conn, to: page_path(conn, :attachments)
        end
    end
  end

  def done(%{assigns: %{current_user: current_user}} = conn, _params) do
    js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
    assigns = 
      %{@base_assigns | js: js}
      |> Map.put(:current_user, current_user)
      |> Map.put(:home, page_path(conn, :index))

    render conn, "done.html", assigns
  end

  def print_ref(%{assigns: %{current_user: %{id: id}}} = conn, params) do
    params_id = params["id"] |> String.trim |> String.to_integer
    case params_id do
      ^id ->
        js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
        assigns = 
          %{@base_assigns | js: js}
          |> Map.put(:details, Recruit.get_applicant_details(id))
          |> Map.put(:passport, Recruit.get_applicant_photo(id))

        render conn, "print_ref.html", assigns

      _ -> 
        send_resp(conn, :ok, "INVALID URL")
    end
  end

  def print_referee(%{assigns: %{current_user: %{id: id}}} = conn, params) do
    params_id = params["id"] |> String.trim |> String.to_integer
    case params_id do
      ^id ->
        js = @base_assigns[:js] ++ ["/js/controllers/recruit/recruitRegistrationController.js"]
        assigns = 
          %{@base_assigns | js: js}
          |> Map.put(:details, Recruit.get_applicant_details(id))
          |> Map.put(:passport, Recruit.get_applicant_photo(id))

        render conn, "print_referee.html", assigns

      _ -> 
        send_resp(conn, :ok, "INVALID URL")
    end
  end

  def get_file(conn, %{"file" => file}) do
    conn
    |> put_resp_content_type(mime_type(file))
    |> put_resp_header("content-disposition", "attachment; filename=#{file}")
    |> send_file(200, "#{@file_store}/#{file}")
  end

  defp mime_type(file) do
    case file |> String.split(".", trim: true) |> List.last do
      "jpg" -> "image/jpg"
      "jpeg" -> "image/jpeg"
      "png" -> "image/png"
      "pdf" -> "application/pdf"
      "doc" -> "application/msword"
      "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      x -> x
    end
  end
end
