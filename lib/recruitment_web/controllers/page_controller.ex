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

  plug RecruitmentWeb.Plug.EnsureAuthenticated when action not in [:index, :login_signup, :logout]

  def index(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        render conn, "index.html", @base_assigns

      _ -> 
        redirect conn, to: page_path(conn, :positions)
    end
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
            lname = params["lname"]
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
                    case Recruit.create_recruit(%{fname: fname, lname: lname, email: email, password: password}) do
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
        email = params["email"]
        password = params["password"]
        
        case Recruit.signin_with_email_and_password(conn, email, password) do
          {:ok, %{assigns: %{current_user: %{completed: completed}}} = conn} ->
            case completed do
              1 -> redirect conn, to: page_path(conn, :done)
              _ -> redirect conn, to: page_path(conn, :positions)
            end

          {:error, reason, conn} ->
            Logger.error "Could not login after signup because of #{inspect reason}"

            assigns = Map.put(@base_assigns, :loginErrorMessage, "Invalid email or password")
            render conn, "index.html", assigns
        end
    end
  end

  def logout(conn, _) do
    conn
    |> Recruit.signout
    |> redirect(to: page_path(conn, :index))
  end

  def positions(%{assigns: %{user_id: user_id}} = conn, _params) do
    js = @base_assigns[:js] ++ ["public/js/controllers/recruit/recruitRegistrationController.js"]
    assigns = 
      %{@base_assigns | js: js}
      |> Map.put(:msg, "Please select position")
      |> Map.put(:user_id, user_id)

    render conn, "positions.html", assigns
  end

  def positions_post(conn, _params) do
    # TODO: Flesh out
    conn
  end

  def registration(%{assigns: %{current_user: current_user}} = conn, _params) do
    current_user = Recruit.load_personal_details(current_user)
    assigns = 
      @base_assigns
      |> Map.put(:current_user, current_user)

    render conn, "registration.html", assigns
  end
end
