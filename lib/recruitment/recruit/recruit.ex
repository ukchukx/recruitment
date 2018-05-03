defmodule Recruitment.Recruit do
  @moduledoc """
  The Recruit context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Plug.Conn
  alias Recruitment.Repo
  require Logger

  alias Recruitment.Recruit.{
    Recruit,
    PersonalDetail,
    Lga,
    Country,
    AttachmentList,
    Attachment,
    WorkExperience,
    ProfessionalQualification,
    EducationalQualification,
    Position,
    SubPosition
  }


  @doc """
  Returns the list of recruit.

  ## Examples

      iex> list_recruit()
      [%Recruit{}, ...]

  """
  def list_recruit do
    Repo.all(Recruit)
  end

  @doc """
  Gets a single Recruit.

  Raises `Ecto.NoResultsError` if the Recruit does not exist.

  ## Examples

      iex> get_Recruit!(123)
      %Recruit{}

      iex> get_Recruit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recruit!(id), do: Repo.get!(Recruit, id)

  def email_exists(email) do
    Repo.all(from r in Recruit, where: r.email > ^email, select: r.email)
    |> length
    |> Kernel.!=(0)
  end

  def load_chosen_position(id) do
    SubPosition
    |> join(:inner, [s], p in Position, s.sub_position_id == p.id)
    |> where([s, _p], s.sub_position_id == ^id)
    |> select([s, p], %{id: p.id, 
      title: p.title, short_code: p.short_code, status: p.status, 
      sub_position_id: s.sub_position_id, position_id: s.position_id, 
      sub_title: s.sub_title, hint: s.hint, sstatus: s.status})
    |> Repo.all
    |> List.first
  end

  def set_complete(%Recruit{id: id} = recruit) do
    PersonalDetail
    |> join(:inner, [p], r in Recruit, r.id == p.recruit_id)
    |> join(:inner, [p, _r], l in Lga, p.permState == l.state)
    |> join(:inner, [_p, r, _l], pos in Position, pos.id == r.position_category)
    |> join(:inner, [_p, r, _l, _pos], s in SubPosition, s.sub_position_id == r.position_applied_for)
    |> where([p, _r, _l, _pos, _s], p.recruit_id == ^id)
    |> select([_p, _r, l, pos, s], [l.state_short_code, pos.short_code, s.sub_position_id])
    |> limit(1)
    |> Repo.all
    |> List.first
    |> case do
      [state_short_code, short_code, sub_position_id] ->
        rand = :rand.uniform() * (100000000 - 10000000) + 10000000 |> trunc
        attrs = %{
          reference: "NPS/#{state_short_code}/#{short_code}#{sub_position_id}/#{rand}",
          completed: 1
        }
        update_recruit(current_user, attrs)
        
      x -> 
       Logger.error("Error in set_complete: #{inspect x}") 
       {:error, :set_complete_failed}
    end 
  end

  def signin_with_email_and_password(conn, email, pass) do
    recruit = Repo.get_by(Recruit, email: email)
    cond do
      recruit && checkpw(pass, recruit.password) ->
      {:ok, signin(conn, recruit)}
      recruit ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def signin(conn, %Recruit{}=recruit) do
    conn
    |> assign(:current_user, recruit)
    |> put_session(:user_id, recruit.id)
    |> configure_session(renew: true)
  end

  def signout(conn), do: configure_session(conn, drop: true)


  @doc """
  Creates a Recruit.

  ## Examples

      iex> create_Recruit(%{field: value})
      {:ok, %Recruit{}}

      iex> create_Recruit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recruit(attrs \\ %{}) do
    %Recruit{}
    |> Recruit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Recruit.

  ## Examples

      iex> update_Recruit(Recruit, %{field: new_value})
      {:ok, %Recruit{}}

      iex> update_Recruit(Recruit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recruit(%Recruit{} = recruit, attrs) do
    recruit
    |> Recruit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Recruit.

  ## Examples

      iex> delete_Recruit(Recruit)
      {:ok, %Recruit{}}

      iex> delete_Recruit(Recruit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recruit(%Recruit{} = recruit) do
    Repo.delete(recruit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Recruit changes.

  ## Examples

      iex> change_recruit(Recruit)
      %Ecto.Changeset{source: %Recruit{}}

  """
  def change_recruit(%Recruit{} = recruit) do
    Recruit.changeset(recruit, %{})
  end

  @doc """
  Returns the list of personal_details.

  ## Examples

      iex> list_personal_details()
      [%PersonalDetail{}, ...]

  """
  def list_personal_details do
    Repo.all(PersonalDetail)
  end

  def load_personal_details(%Recruit{} = recruit) do
    Repo.preload(recruit, :personal_detail)
  end

  def load_educational_qualifications(%Recruit{} = recruit) do
    Repo.preload(recruit, :educational_qualifications)
  end

  def load_professional_qualifications(%Recruit{} = recruit) do
    Repo.preload(recruit, :professional_qualifications)
  end

  def load_work_experience(%Recruit{} = recruit) do
    Repo.preload(recruit, :work_experience)
  end

  def load_attachments(%Recruit{} = recruit) do
    Repo.preload(recruit, :attachments)
  end

  @doc """
  Gets a single personal_detail.

  Raises `Ecto.NoResultsError` if the Personal detail does not exist.

  ## Examples

      iex> get_personal_detail!(123)
      %PersonalDetail{}

      iex> get_personal_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personal_detail!(id), do: Repo.get!(PersonalDetail, id)

  @doc """
  Creates a personal_detail.

  ## Examples

      iex> create_personal_detail(%{field: value})
      {:ok, %PersonalDetail{}}

      iex> create_personal_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personal_detail(attrs \\ %{}) do
    %PersonalDetail{}
    |> PersonalDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a personal_detail.

  ## Examples

      iex> update_personal_detail(personal_detail, %{field: new_value})
      {:ok, %PersonalDetail{}}

      iex> update_personal_detail(personal_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personal_detail(%PersonalDetail{} = personal_detail, attrs) do
    personal_detail
    |> PersonalDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PersonalDetail.

  ## Examples

      iex> delete_personal_detail(personal_detail)
      {:ok, %PersonalDetail{}}

      iex> delete_personal_detail(personal_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personal_detail(%PersonalDetail{} = personal_detail) do
    Repo.delete(personal_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personal_detail changes.

  ## Examples

      iex> change_personal_detail(personal_detail)
      %Ecto.Changeset{source: %PersonalDetail{}}

  """
  def change_personal_detail(%PersonalDetail{} = personal_detail) do
    PersonalDetail.changeset(personal_detail, %{})
  end

  @doc """
  Returns the list of educational_qualifications.

  ## Examples

      iex> list_educational_qualifications()
      [%EducationalQualification{}, ...]

  """
  def list_educational_qualifications do
    Repo.all(EducationalQualification)
  end

  @doc """
  Gets a single educational_qualification.

  Raises `Ecto.NoResultsError` if the Educational qualification does not exist.

  ## Examples

      iex> get_educational_qualification!(123)
      %EducationalQualification{}

      iex> get_educational_qualification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_educational_qualification!(id), do: Repo.get!(EducationalQualification, id)

  @doc """
  Creates a educational_qualification.

  ## Examples

      iex> create_educational_qualification(%{field: value})
      {:ok, %EducationalQualification{}}

      iex> create_educational_qualification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_educational_qualification(attrs \\ %{}) do
    %EducationalQualification{}
    |> EducationalQualification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a educational_qualification.

  ## Examples

      iex> update_educational_qualification(educational_qualification, %{field: new_value})
      {:ok, %EducationalQualification{}}

      iex> update_educational_qualification(educational_qualification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_educational_qualification(%EducationalQualification{} = educational_qualification, attrs) do
    educational_qualification
    |> EducationalQualification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EducationalQualification.

  ## Examples

      iex> delete_educational_qualification(educational_qualification)
      {:ok, %EducationalQualification{}}

      iex> delete_educational_qualification(educational_qualification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_educational_qualification(%EducationalQualification{} = educational_qualification) do
    Repo.delete(educational_qualification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking educational_qualification changes.

  ## Examples

      iex> change_educational_qualification(educational_qualification)
      %Ecto.Changeset{source: %EducationalQualification{}}

  """
  def change_educational_qualification(%EducationalQualification{} = educational_qualification) do
    EducationalQualification.changeset(educational_qualification, %{})
  end

  @doc """
  Returns the list of professional_qualifications.

  ## Examples

      iex> list_professional_qualifications()
      [%ProfessionalQualification{}, ...]

  """
  def list_professional_qualifications do
    Repo.all(ProfessionalQualification)
  end

  @doc """
  Gets a single professional_qualification.

  Raises `Ecto.NoResultsError` if the Professional qualification does not exist.

  ## Examples

      iex> get_professional_qualification!(123)
      %ProfessionalQualification{}

      iex> get_professional_qualification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_professional_qualification!(id), do: Repo.get!(ProfessionalQualification, id)

  @doc """
  Creates a professional_qualification.

  ## Examples

      iex> create_professional_qualification(%{field: value})
      {:ok, %ProfessionalQualification{}}

      iex> create_professional_qualification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_professional_qualification(attrs \\ %{}) do
    %ProfessionalQualification{}
    |> ProfessionalQualification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a professional_qualification.

  ## Examples

      iex> update_professional_qualification(professional_qualification, %{field: new_value})
      {:ok, %ProfessionalQualification{}}

      iex> update_professional_qualification(professional_qualification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_professional_qualification(%ProfessionalQualification{} = professional_qualification, attrs) do
    professional_qualification
    |> ProfessionalQualification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProfessionalQualification.

  ## Examples

      iex> delete_professional_qualification(professional_qualification)
      {:ok, %ProfessionalQualification{}}

      iex> delete_professional_qualification(professional_qualification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_professional_qualification(%ProfessionalQualification{} = professional_qualification) do
    Repo.delete(professional_qualification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking professional_qualification changes.

  ## Examples

      iex> change_professional_qualification(professional_qualification)
      %Ecto.Changeset{source: %ProfessionalQualification{}}

  """
  def change_professional_qualification(%ProfessionalQualification{} = professional_qualification) do
    ProfessionalQualification.changeset(professional_qualification, %{})
  end

  @doc """
  Returns the list of work_experience.

  ## Examples

      iex> list_work_experience()
      [%WorkExperience{}, ...]

  """
  def list_work_experience do
    Repo.all(WorkExperience)
  end

  @doc """
  Gets a single work_experience.

  Raises `Ecto.NoResultsError` if the Work experience does not exist.

  ## Examples

      iex> get_work_experience!(123)
      %WorkExperience{}

      iex> get_work_experience!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_experience!(id), do: Repo.get!(WorkExperience, id)

  @doc """
  Creates a work_experience.

  ## Examples

      iex> create_work_experience(%{field: value})
      {:ok, %WorkExperience{}}

      iex> create_work_experience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_experience(attrs \\ %{}) do
    %WorkExperience{}
    |> WorkExperience.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_experience.

  ## Examples

      iex> update_work_experience(work_experience, %{field: new_value})
      {:ok, %WorkExperience{}}

      iex> update_work_experience(work_experience, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_experience(%WorkExperience{} = work_experience, attrs) do
    work_experience
    |> WorkExperience.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WorkExperience.

  ## Examples

      iex> delete_work_experience(work_experience)
      {:ok, %WorkExperience{}}

      iex> delete_work_experience(work_experience)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_experience(%WorkExperience{} = work_experience) do
    Repo.delete(work_experience)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_experience changes.

  ## Examples

      iex> change_work_experience(work_experience)
      %Ecto.Changeset{source: %WorkExperience{}}

  """
  def change_work_experience(%WorkExperience{} = work_experience) do
    WorkExperience.changeset(work_experience, %{})
  end

  @doc """
  Returns the list of attachments.

  ## Examples

      iex> list_attachments()
      [%Attachment{}, ...]

  """
  def list_attachments do
    Repo.all(Attachment)
  end

  @doc """
  Gets a single attachment.

  Raises `Ecto.NoResultsError` if the Attachment does not exist.

  ## Examples

      iex> get_attachment!(123)
      %Attachment{}

      iex> get_attachment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attachment!(id), do: Repo.get!(Attachment, id)

  @doc """
  Creates a attachment.

  ## Examples

      iex> create_attachment(%{field: value})
      {:ok, %Attachment{}}

      iex> create_attachment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attachment(attrs \\ %{}) do
    %Attachment{}
    |> Attachment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attachment.

  ## Examples

      iex> update_attachment(attachment, %{field: new_value})
      {:ok, %Attachment{}}

      iex> update_attachment(attachment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attachment(%Attachment{} = attachment, attrs) do
    attachment
    |> Attachment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attachment.

  ## Examples

      iex> delete_attachment(attachment)
      {:ok, %Attachment{}}

      iex> delete_attachment(attachment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attachment(%Attachment{} = attachment) do
    Repo.delete(attachment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attachment changes.

  ## Examples

      iex> change_attachment(attachment)
      %Ecto.Changeset{source: %Attachment{}}

  """
  def change_attachment(%Attachment{} = attachment) do
    Attachment.changeset(attachment, %{})
  end

  @doc """
  Returns the list of attachments_list.

  ## Examples

      iex> list_attachments_list()
      [%AttachmentList{}, ...]

  """
  def list_attachments_list do
    Repo.all(AttachmentList)
  end

  @doc """
  Gets a single attachment_list.

  Raises `Ecto.NoResultsError` if the Attachment list does not exist.

  ## Examples

      iex> get_attachment_list!(123)
      %AttachmentList{}

      iex> get_attachment_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attachment_list!(id), do: Repo.get!(AttachmentList, id)

  @doc """
  Creates a attachment_list.

  ## Examples

      iex> create_attachment_list(%{field: value})
      {:ok, %AttachmentList{}}

      iex> create_attachment_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attachment_list(attrs \\ %{}) do
    %AttachmentList{}
    |> AttachmentList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attachment_list.

  ## Examples

      iex> update_attachment_list(attachment_list, %{field: new_value})
      {:ok, %AttachmentList{}}

      iex> update_attachment_list(attachment_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attachment_list(%AttachmentList{} = attachment_list, attrs) do
    attachment_list
    |> AttachmentList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AttachmentList.

  ## Examples

      iex> delete_attachment_list(attachment_list)
      {:ok, %AttachmentList{}}

      iex> delete_attachment_list(attachment_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attachment_list(%AttachmentList{} = attachment_list) do
    Repo.delete(attachment_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attachment_list changes.

  ## Examples

      iex> change_attachment_list(attachment_list)
      %Ecto.Changeset{source: %AttachmentList{}}

  """
  def change_attachment_list(%AttachmentList{} = attachment_list) do
    AttachmentList.changeset(attachment_list, %{})
  end

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries do
    Repo.all(Country)
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{source: %Country{}}

  """
  def change_country(%Country{} = country) do
    Country.changeset(country, %{})
  end

  @doc """
  Returns the list of lgas.

  ## Examples

      iex> list_lgas()
      [%Lga{}, ...]

  """
  def list_lgas do
    Repo.all(Lga)
  end

  @doc """
  Gets a single lga.

  Raises `Ecto.NoResultsError` if the Lga does not exist.

  ## Examples

      iex> get_lga!(123)
      %Lga{}

      iex> get_lga!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lga!(id), do: Repo.get!(Lga, id)

  @doc """
  Creates a lga.

  ## Examples

      iex> create_lga(%{field: value})
      {:ok, %Lga{}}

      iex> create_lga(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lga(attrs \\ %{}) do
    %Lga{}
    |> Lga.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lga.

  ## Examples

      iex> update_lga(lga, %{field: new_value})
      {:ok, %Lga{}}

      iex> update_lga(lga, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lga(%Lga{} = lga, attrs) do
    lga
    |> Lga.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Lga.

  ## Examples

      iex> delete_lga(lga)
      {:ok, %Lga{}}

      iex> delete_lga(lga)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lga(%Lga{} = lga) do
    Repo.delete(lga)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lga changes.

  ## Examples

      iex> change_lga(lga)
      %Ecto.Changeset{source: %Lga{}}

  """
  def change_lga(%Lga{} = lga) do
    Lga.changeset(lga, %{})
  end

  @doc """
  Returns the list of positions.

  ## Examples

      iex> list_positions()
      [%Position{}, ...]

  """
  def list_positions do
    Repo.all(Position)
  end

  @doc """
  Gets a single position.

  Raises `Ecto.NoResultsError` if the Position does not exist.

  ## Examples

      iex> get_position!(123)
      %Position{}

      iex> get_position!(456)
      ** (Ecto.NoResultsError)

  """
  def get_position!(id), do: Repo.get!(Position, id)

  @doc """
  Creates a position.

  ## Examples

      iex> create_position(%{field: value})
      {:ok, %Position{}}

      iex> create_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position(attrs \\ %{}) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a position.

  ## Examples

      iex> update_position(position, %{field: new_value})
      {:ok, %Position{}}

      iex> update_position(position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Position.

  ## Examples

      iex> delete_position(position)
      {:ok, %Position{}}

      iex> delete_position(position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_position(%Position{} = position) do
    Repo.delete(position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking position changes.

  ## Examples

      iex> change_position(position)
      %Ecto.Changeset{source: %Position{}}

  """
  def change_position(%Position{} = position) do
    Position.changeset(position, %{})
  end

  @doc """
  Returns the list of sub_positions.

  ## Examples

      iex> list_sub_positions()
      [%SubPosition{}, ...]

  """
  def list_sub_positions do
    Repo.all(SubPosition)
  end

  @doc """
  Gets a single sub_position.

  Raises `Ecto.NoResultsError` if the Sub position does not exist.

  ## Examples

      iex> get_sub_position!(123)
      %SubPosition{}

      iex> get_sub_position!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sub_position!(id), do: Repo.get!(SubPosition, id)

  @doc """
  Creates a sub_position.

  ## Examples

      iex> create_sub_position(%{field: value})
      {:ok, %SubPosition{}}

      iex> create_sub_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sub_position(attrs \\ %{}) do
    %SubPosition{}
    |> SubPosition.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sub_position.

  ## Examples

      iex> update_sub_position(sub_position, %{field: new_value})
      {:ok, %SubPosition{}}

      iex> update_sub_position(sub_position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sub_position(%SubPosition{} = sub_position, attrs) do
    sub_position
    |> SubPosition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SubPosition.

  ## Examples

      iex> delete_sub_position(sub_position)
      {:ok, %SubPosition{}}

      iex> delete_sub_position(sub_position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sub_position(%SubPosition{} = sub_position) do
    Repo.delete(sub_position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sub_position changes.

  ## Examples

      iex> change_sub_position(sub_position)
      %Ecto.Changeset{source: %SubPosition{}}

  """
  def change_sub_position(%SubPosition{} = sub_position) do
    SubPosition.changeset(sub_position, %{})
  end
end
