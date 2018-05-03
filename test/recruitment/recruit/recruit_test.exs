defmodule Recruitment.RecruitTest do
  use Recruitment.DataCase

  alias Recruitment.Recruit

  describe "recruit" do
    alias Recruitment.Recruit.Data

    @valid_attrs %{email: "some email", fname: "some fname", password: "some password", sname: "some sname"}
    @update_attrs %{email: "some updated email", fname: "some updated fname", password: "some updated password", sname: "some updated sname"}
    @invalid_attrs %{email: nil, fname: nil, password: nil, sname: nil}

    def data_fixture(attrs \\ %{}) do
      {:ok, data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_data()

      data
    end

    test "list_recruit/0 returns all recruit" do
      data = data_fixture()
      assert Recruit.list_recruit() == [data]
    end

    test "get_data!/1 returns the data with given id" do
      data = data_fixture()
      assert Recruit.get_data!(data.id) == data
    end

    test "create_data/1 with valid data creates a data" do
      assert {:ok, %Data{} = data} = Recruit.create_data(@valid_attrs)
      assert data.email == "some email"
      assert data.fname == "some fname"
      assert data.password == "some password"
      assert data.sname == "some sname"
    end

    test "create_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_data(@invalid_attrs)
    end

    test "update_data/2 with valid data updates the data" do
      data = data_fixture()
      assert {:ok, data} = Recruit.update_data(data, @update_attrs)
      assert %Data{} = data
      assert data.email == "some updated email"
      assert data.fname == "some updated fname"
      assert data.password == "some updated password"
      assert data.sname == "some updated sname"
    end

    test "update_data/2 with invalid data returns error changeset" do
      data = data_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_data(data, @invalid_attrs)
      assert data == Recruit.get_data!(data.id)
    end

    test "delete_data/1 deletes the data" do
      data = data_fixture()
      assert {:ok, %Data{}} = Recruit.delete_data(data)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_data!(data.id) end
    end

    test "change_data/1 returns a data changeset" do
      data = data_fixture()
      assert %Ecto.Changeset{} = Recruit.change_data(data)
    end
  end

  describe "personal_details" do
    alias Recruitment.Recruit.PersonalDetail

    @valid_attrs %{accepted: 42, completed: 42, curAddress: "some curAddress", curLga: "some curLga", curState: "some curState", curStreet: "some curStreet", denied: 42, dob: "some dob", gender: "some gender", height: "some height", mname: "some mname", nationality: "some nationality", nin: "some nin", permAddress: "some permAddress", permLga: "some permLga", permState: "some permState", permStreet: "some permStreet", phone: "some phone", prefAddress: "some prefAddress", status: 42, title: "some title", verified: 42}
    @update_attrs %{accepted: 43, completed: 43, curAddress: "some updated curAddress", curLga: "some updated curLga", curState: "some updated curState", curStreet: "some updated curStreet", denied: 43, dob: "some updated dob", gender: "some updated gender", height: "some updated height", mname: "some updated mname", nationality: "some updated nationality", nin: "some updated nin", permAddress: "some updated permAddress", permLga: "some updated permLga", permState: "some updated permState", permStreet: "some updated permStreet", phone: "some updated phone", prefAddress: "some updated prefAddress", status: 43, title: "some updated title", verified: 43}
    @invalid_attrs %{accepted: nil, completed: nil, curAddress: nil, curLga: nil, curState: nil, curStreet: nil, denied: nil, dob: nil, gender: nil, height: nil, mname: nil, nationality: nil, nin: nil, permAddress: nil, permLga: nil, permState: nil, permStreet: nil, phone: nil, prefAddress: nil, status: nil, title: nil, verified: nil}

    def personal_detail_fixture(attrs \\ %{}) do
      {:ok, personal_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_personal_detail()

      personal_detail
    end

    test "list_personal_details/0 returns all personal_details" do
      personal_detail = personal_detail_fixture()
      assert Recruit.list_personal_details() == [personal_detail]
    end

    test "get_personal_detail!/1 returns the personal_detail with given id" do
      personal_detail = personal_detail_fixture()
      assert Recruit.get_personal_detail!(personal_detail.id) == personal_detail
    end

    test "create_personal_detail/1 with valid data creates a personal_detail" do
      assert {:ok, %PersonalDetail{} = personal_detail} = Recruit.create_personal_detail(@valid_attrs)
      assert personal_detail.accepted == 42
      assert personal_detail.completed == 42
      assert personal_detail.curAddress == "some curAddress"
      assert personal_detail.curLga == "some curLga"
      assert personal_detail.curState == "some curState"
      assert personal_detail.curStreet == "some curStreet"
      assert personal_detail.denied == 42
      assert personal_detail.dob == "some dob"
      assert personal_detail.gender == "some gender"
      assert personal_detail.height == "some height"
      assert personal_detail.mname == "some mname"
      assert personal_detail.nationality == "some nationality"
      assert personal_detail.nin == "some nin"
      assert personal_detail.permAddress == "some permAddress"
      assert personal_detail.permLga == "some permLga"
      assert personal_detail.permState == "some permState"
      assert personal_detail.permStreet == "some permStreet"
      assert personal_detail.phone == "some phone"
      assert personal_detail.prefAddress == "some prefAddress"
      assert personal_detail.status == 42
      assert personal_detail.title == "some title"
      assert personal_detail.verified == 42
    end

    test "create_personal_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_personal_detail(@invalid_attrs)
    end

    test "update_personal_detail/2 with valid data updates the personal_detail" do
      personal_detail = personal_detail_fixture()
      assert {:ok, personal_detail} = Recruit.update_personal_detail(personal_detail, @update_attrs)
      assert %PersonalDetail{} = personal_detail
      assert personal_detail.accepted == 43
      assert personal_detail.completed == 43
      assert personal_detail.curAddress == "some updated curAddress"
      assert personal_detail.curLga == "some updated curLga"
      assert personal_detail.curState == "some updated curState"
      assert personal_detail.curStreet == "some updated curStreet"
      assert personal_detail.denied == 43
      assert personal_detail.dob == "some updated dob"
      assert personal_detail.gender == "some updated gender"
      assert personal_detail.height == "some updated height"
      assert personal_detail.mname == "some updated mname"
      assert personal_detail.nationality == "some updated nationality"
      assert personal_detail.nin == "some updated nin"
      assert personal_detail.permAddress == "some updated permAddress"
      assert personal_detail.permLga == "some updated permLga"
      assert personal_detail.permState == "some updated permState"
      assert personal_detail.permStreet == "some updated permStreet"
      assert personal_detail.phone == "some updated phone"
      assert personal_detail.prefAddress == "some updated prefAddress"
      assert personal_detail.status == 43
      assert personal_detail.title == "some updated title"
      assert personal_detail.verified == 43
    end

    test "update_personal_detail/2 with invalid data returns error changeset" do
      personal_detail = personal_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_personal_detail(personal_detail, @invalid_attrs)
      assert personal_detail == Recruit.get_personal_detail!(personal_detail.id)
    end

    test "delete_personal_detail/1 deletes the personal_detail" do
      personal_detail = personal_detail_fixture()
      assert {:ok, %PersonalDetail{}} = Recruit.delete_personal_detail(personal_detail)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_personal_detail!(personal_detail.id) end
    end

    test "change_personal_detail/1 returns a personal_detail changeset" do
      personal_detail = personal_detail_fixture()
      assert %Ecto.Changeset{} = Recruit.change_personal_detail(personal_detail)
    end
  end

  describe "educational_qualifications" do
    alias Recruitment.Recruit.EducationalQualification

    @valid_attrs %{city: "some city", classification: "some classification", country: "some country", course_of_study: "some course_of_study", enddate: "some enddate", institution: "some institution", qualification: "some qualification", startdate: "some startdate", type: "some type"}
    @update_attrs %{city: "some updated city", classification: "some updated classification", country: "some updated country", course_of_study: "some updated course_of_study", enddate: "some updated enddate", institution: "some updated institution", qualification: "some updated qualification", startdate: "some updated startdate", type: "some updated type"}
    @invalid_attrs %{city: nil, classification: nil, country: nil, course_of_study: nil, enddate: nil, institution: nil, qualification: nil, startdate: nil, type: nil}

    def educational_qualification_fixture(attrs \\ %{}) do
      {:ok, educational_qualification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_educational_qualification()

      educational_qualification
    end

    test "list_educational_qualifications/0 returns all educational_qualifications" do
      educational_qualification = educational_qualification_fixture()
      assert Recruit.list_educational_qualifications() == [educational_qualification]
    end

    test "get_educational_qualification!/1 returns the educational_qualification with given id" do
      educational_qualification = educational_qualification_fixture()
      assert Recruit.get_educational_qualification!(educational_qualification.id) == educational_qualification
    end

    test "create_educational_qualification/1 with valid data creates a educational_qualification" do
      assert {:ok, %EducationalQualification{} = educational_qualification} = Recruit.create_educational_qualification(@valid_attrs)
      assert educational_qualification.city == "some city"
      assert educational_qualification.classification == "some classification"
      assert educational_qualification.country == "some country"
      assert educational_qualification.course_of_study == "some course_of_study"
      assert educational_qualification.enddate == "some enddate"
      assert educational_qualification.institution == "some institution"
      assert educational_qualification.qualification == "some qualification"
      assert educational_qualification.startdate == "some startdate"
      assert educational_qualification.type == "some type"
    end

    test "create_educational_qualification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_educational_qualification(@invalid_attrs)
    end

    test "update_educational_qualification/2 with valid data updates the educational_qualification" do
      educational_qualification = educational_qualification_fixture()
      assert {:ok, educational_qualification} = Recruit.update_educational_qualification(educational_qualification, @update_attrs)
      assert %EducationalQualification{} = educational_qualification
      assert educational_qualification.city == "some updated city"
      assert educational_qualification.classification == "some updated classification"
      assert educational_qualification.country == "some updated country"
      assert educational_qualification.course_of_study == "some updated course_of_study"
      assert educational_qualification.enddate == "some updated enddate"
      assert educational_qualification.institution == "some updated institution"
      assert educational_qualification.qualification == "some updated qualification"
      assert educational_qualification.startdate == "some updated startdate"
      assert educational_qualification.type == "some updated type"
    end

    test "update_educational_qualification/2 with invalid data returns error changeset" do
      educational_qualification = educational_qualification_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_educational_qualification(educational_qualification, @invalid_attrs)
      assert educational_qualification == Recruit.get_educational_qualification!(educational_qualification.id)
    end

    test "delete_educational_qualification/1 deletes the educational_qualification" do
      educational_qualification = educational_qualification_fixture()
      assert {:ok, %EducationalQualification{}} = Recruit.delete_educational_qualification(educational_qualification)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_educational_qualification!(educational_qualification.id) end
    end

    test "change_educational_qualification/1 returns a educational_qualification changeset" do
      educational_qualification = educational_qualification_fixture()
      assert %Ecto.Changeset{} = Recruit.change_educational_qualification(educational_qualification)
    end
  end

  describe "professional_qualifications" do
    alias Recruitment.Recruit.ProfessionalQualification

    @valid_attrs %{city: "some city", classification: "some classification", country: "some country", enddate: "some enddate", fos: "some fos", grade: "some grade", highest_qual: "some highest_qual", institution: "some institution", level: "some level", qualification: "some qualification", reg_no: "some reg_no", startdate: "some startdate"}
    @update_attrs %{city: "some updated city", classification: "some updated classification", country: "some updated country", enddate: "some updated enddate", fos: "some updated fos", grade: "some updated grade", highest_qual: "some updated highest_qual", institution: "some updated institution", level: "some updated level", qualification: "some updated qualification", reg_no: "some updated reg_no", startdate: "some updated startdate"}
    @invalid_attrs %{city: nil, classification: nil, country: nil, enddate: nil, fos: nil, grade: nil, highest_qual: nil, institution: nil, level: nil, qualification: nil, reg_no: nil, startdate: nil}

    def professional_qualification_fixture(attrs \\ %{}) do
      {:ok, professional_qualification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_professional_qualification()

      professional_qualification
    end

    test "list_professional_qualifications/0 returns all professional_qualifications" do
      professional_qualification = professional_qualification_fixture()
      assert Recruit.list_professional_qualifications() == [professional_qualification]
    end

    test "get_professional_qualification!/1 returns the professional_qualification with given id" do
      professional_qualification = professional_qualification_fixture()
      assert Recruit.get_professional_qualification!(professional_qualification.id) == professional_qualification
    end

    test "create_professional_qualification/1 with valid data creates a professional_qualification" do
      assert {:ok, %ProfessionalQualification{} = professional_qualification} = Recruit.create_professional_qualification(@valid_attrs)
      assert professional_qualification.city == "some city"
      assert professional_qualification.classification == "some classification"
      assert professional_qualification.country == "some country"
      assert professional_qualification.enddate == "some enddate"
      assert professional_qualification.fos == "some fos"
      assert professional_qualification.grade == "some grade"
      assert professional_qualification.highest_qual == "some highest_qual"
      assert professional_qualification.institution == "some institution"
      assert professional_qualification.level == "some level"
      assert professional_qualification.qualification == "some qualification"
      assert professional_qualification.reg_no == "some reg_no"
      assert professional_qualification.startdate == "some startdate"
    end

    test "create_professional_qualification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_professional_qualification(@invalid_attrs)
    end

    test "update_professional_qualification/2 with valid data updates the professional_qualification" do
      professional_qualification = professional_qualification_fixture()
      assert {:ok, professional_qualification} = Recruit.update_professional_qualification(professional_qualification, @update_attrs)
      assert %ProfessionalQualification{} = professional_qualification
      assert professional_qualification.city == "some updated city"
      assert professional_qualification.classification == "some updated classification"
      assert professional_qualification.country == "some updated country"
      assert professional_qualification.enddate == "some updated enddate"
      assert professional_qualification.fos == "some updated fos"
      assert professional_qualification.grade == "some updated grade"
      assert professional_qualification.highest_qual == "some updated highest_qual"
      assert professional_qualification.institution == "some updated institution"
      assert professional_qualification.level == "some updated level"
      assert professional_qualification.qualification == "some updated qualification"
      assert professional_qualification.reg_no == "some updated reg_no"
      assert professional_qualification.startdate == "some updated startdate"
    end

    test "update_professional_qualification/2 with invalid data returns error changeset" do
      professional_qualification = professional_qualification_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_professional_qualification(professional_qualification, @invalid_attrs)
      assert professional_qualification == Recruit.get_professional_qualification!(professional_qualification.id)
    end

    test "delete_professional_qualification/1 deletes the professional_qualification" do
      professional_qualification = professional_qualification_fixture()
      assert {:ok, %ProfessionalQualification{}} = Recruit.delete_professional_qualification(professional_qualification)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_professional_qualification!(professional_qualification.id) end
    end

    test "change_professional_qualification/1 returns a professional_qualification changeset" do
      professional_qualification = professional_qualification_fixture()
      assert %Ecto.Changeset{} = Recruit.change_professional_qualification(professional_qualification)
    end
  end

  describe "work_experience" do
    alias Recruitment.Recruit.WorkExperience

    @valid_attrs %{enddate: "some enddate", organization: "some organization", role: "some role", startdate: "some startdate"}
    @update_attrs %{enddate: "some updated enddate", organization: "some updated organization", role: "some updated role", startdate: "some updated startdate"}
    @invalid_attrs %{enddate: nil, organization: nil, role: nil, startdate: nil}

    def work_experience_fixture(attrs \\ %{}) do
      {:ok, work_experience} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_work_experience()

      work_experience
    end

    test "list_work_experience/0 returns all work_experience" do
      work_experience = work_experience_fixture()
      assert Recruit.list_work_experience() == [work_experience]
    end

    test "get_work_experience!/1 returns the work_experience with given id" do
      work_experience = work_experience_fixture()
      assert Recruit.get_work_experience!(work_experience.id) == work_experience
    end

    test "create_work_experience/1 with valid data creates a work_experience" do
      assert {:ok, %WorkExperience{} = work_experience} = Recruit.create_work_experience(@valid_attrs)
      assert work_experience.enddate == "some enddate"
      assert work_experience.organization == "some organization"
      assert work_experience.role == "some role"
      assert work_experience.startdate == "some startdate"
    end

    test "create_work_experience/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_work_experience(@invalid_attrs)
    end

    test "update_work_experience/2 with valid data updates the work_experience" do
      work_experience = work_experience_fixture()
      assert {:ok, work_experience} = Recruit.update_work_experience(work_experience, @update_attrs)
      assert %WorkExperience{} = work_experience
      assert work_experience.enddate == "some updated enddate"
      assert work_experience.organization == "some updated organization"
      assert work_experience.role == "some updated role"
      assert work_experience.startdate == "some updated startdate"
    end

    test "update_work_experience/2 with invalid data returns error changeset" do
      work_experience = work_experience_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_work_experience(work_experience, @invalid_attrs)
      assert work_experience == Recruit.get_work_experience!(work_experience.id)
    end

    test "delete_work_experience/1 deletes the work_experience" do
      work_experience = work_experience_fixture()
      assert {:ok, %WorkExperience{}} = Recruit.delete_work_experience(work_experience)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_work_experience!(work_experience.id) end
    end

    test "change_work_experience/1 returns a work_experience changeset" do
      work_experience = work_experience_fixture()
      assert %Ecto.Changeset{} = Recruit.change_work_experience(work_experience)
    end
  end

  describe "attachments" do
    alias Recruitment.Recruit.Attachment

    @valid_attrs %{path: "some path", title: "some title"}
    @update_attrs %{path: "some updated path", title: "some updated title"}
    @invalid_attrs %{path: nil, title: nil}

    def attachment_fixture(attrs \\ %{}) do
      {:ok, attachment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_attachment()

      attachment
    end

    test "list_attachments/0 returns all attachments" do
      attachment = attachment_fixture()
      assert Recruit.list_attachments() == [attachment]
    end

    test "get_attachment!/1 returns the attachment with given id" do
      attachment = attachment_fixture()
      assert Recruit.get_attachment!(attachment.id) == attachment
    end

    test "create_attachment/1 with valid data creates a attachment" do
      assert {:ok, %Attachment{} = attachment} = Recruit.create_attachment(@valid_attrs)
      assert attachment.path == "some path"
      assert attachment.title == "some title"
    end

    test "create_attachment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_attachment(@invalid_attrs)
    end

    test "update_attachment/2 with valid data updates the attachment" do
      attachment = attachment_fixture()
      assert {:ok, attachment} = Recruit.update_attachment(attachment, @update_attrs)
      assert %Attachment{} = attachment
      assert attachment.path == "some updated path"
      assert attachment.title == "some updated title"
    end

    test "update_attachment/2 with invalid data returns error changeset" do
      attachment = attachment_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_attachment(attachment, @invalid_attrs)
      assert attachment == Recruit.get_attachment!(attachment.id)
    end

    test "delete_attachment/1 deletes the attachment" do
      attachment = attachment_fixture()
      assert {:ok, %Attachment{}} = Recruit.delete_attachment(attachment)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_attachment!(attachment.id) end
    end

    test "change_attachment/1 returns a attachment changeset" do
      attachment = attachment_fixture()
      assert %Ecto.Changeset{} = Recruit.change_attachment(attachment)
    end
  end

  describe "attachments_list" do
    alias Recruitment.Recruit.AttachmentList

    @valid_attrs %{degree: "some degree", status: "some status"}
    @update_attrs %{degree: "some updated degree", status: "some updated status"}
    @invalid_attrs %{degree: nil, status: nil}

    def attachment_list_fixture(attrs \\ %{}) do
      {:ok, attachment_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_attachment_list()

      attachment_list
    end

    test "list_attachments_list/0 returns all attachments_list" do
      attachment_list = attachment_list_fixture()
      assert Recruit.list_attachments_list() == [attachment_list]
    end

    test "get_attachment_list!/1 returns the attachment_list with given id" do
      attachment_list = attachment_list_fixture()
      assert Recruit.get_attachment_list!(attachment_list.id) == attachment_list
    end

    test "create_attachment_list/1 with valid data creates a attachment_list" do
      assert {:ok, %AttachmentList{} = attachment_list} = Recruit.create_attachment_list(@valid_attrs)
      assert attachment_list.degree == "some degree"
      assert attachment_list.status == "some status"
    end

    test "create_attachment_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_attachment_list(@invalid_attrs)
    end

    test "update_attachment_list/2 with valid data updates the attachment_list" do
      attachment_list = attachment_list_fixture()
      assert {:ok, attachment_list} = Recruit.update_attachment_list(attachment_list, @update_attrs)
      assert %AttachmentList{} = attachment_list
      assert attachment_list.degree == "some updated degree"
      assert attachment_list.status == "some updated status"
    end

    test "update_attachment_list/2 with invalid data returns error changeset" do
      attachment_list = attachment_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_attachment_list(attachment_list, @invalid_attrs)
      assert attachment_list == Recruit.get_attachment_list!(attachment_list.id)
    end

    test "delete_attachment_list/1 deletes the attachment_list" do
      attachment_list = attachment_list_fixture()
      assert {:ok, %AttachmentList{}} = Recruit.delete_attachment_list(attachment_list)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_attachment_list!(attachment_list.id) end
    end

    test "change_attachment_list/1 returns a attachment_list changeset" do
      attachment_list = attachment_list_fixture()
      assert %Ecto.Changeset{} = Recruit.change_attachment_list(attachment_list)
    end
  end

  describe "countries" do
    alias Recruitment.Recruit.Country

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_country()

      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Recruit.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Recruit.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = Recruit.create_country(@valid_attrs)
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, country} = Recruit.update_country(country, @update_attrs)
      assert %Country{} = country
      assert country.name == "some updated name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_country(country, @invalid_attrs)
      assert country == Recruit.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Recruit.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Recruit.change_country(country)
    end
  end

  describe "lgas" do
    alias Recruitment.Recruit.Lga

    @valid_attrs %{name: "some name", state: "some state"}
    @update_attrs %{name: "some updated name", state: "some updated state"}
    @invalid_attrs %{name: nil, state: nil}

    def lga_fixture(attrs \\ %{}) do
      {:ok, lga} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_lga()

      lga
    end

    test "list_lgas/0 returns all lgas" do
      lga = lga_fixture()
      assert Recruit.list_lgas() == [lga]
    end

    test "get_lga!/1 returns the lga with given id" do
      lga = lga_fixture()
      assert Recruit.get_lga!(lga.id) == lga
    end

    test "create_lga/1 with valid data creates a lga" do
      assert {:ok, %Lga{} = lga} = Recruit.create_lga(@valid_attrs)
      assert lga.name == "some name"
      assert lga.state == "some state"
    end

    test "create_lga/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_lga(@invalid_attrs)
    end

    test "update_lga/2 with valid data updates the lga" do
      lga = lga_fixture()
      assert {:ok, lga} = Recruit.update_lga(lga, @update_attrs)
      assert %Lga{} = lga
      assert lga.name == "some updated name"
      assert lga.state == "some updated state"
    end

    test "update_lga/2 with invalid data returns error changeset" do
      lga = lga_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_lga(lga, @invalid_attrs)
      assert lga == Recruit.get_lga!(lga.id)
    end

    test "delete_lga/1 deletes the lga" do
      lga = lga_fixture()
      assert {:ok, %Lga{}} = Recruit.delete_lga(lga)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_lga!(lga.id) end
    end

    test "change_lga/1 returns a lga changeset" do
      lga = lga_fixture()
      assert %Ecto.Changeset{} = Recruit.change_lga(lga)
    end
  end

  describe "positions" do
    alias Recruitment.Recruit.Position

    @valid_attrs %{short_code: "some short_code", status: 42, title: "some title"}
    @update_attrs %{short_code: "some updated short_code", status: 43, title: "some updated title"}
    @invalid_attrs %{short_code: nil, status: nil, title: nil}

    def position_fixture(attrs \\ %{}) do
      {:ok, position} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_position()

      position
    end

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Recruit.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Recruit.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      assert {:ok, %Position{} = position} = Recruit.create_position(@valid_attrs)
      assert position.short_code == "some short_code"
      assert position.status == 42
      assert position.title == "some title"
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()
      assert {:ok, position} = Recruit.update_position(position, @update_attrs)
      assert %Position{} = position
      assert position.short_code == "some updated short_code"
      assert position.status == 43
      assert position.title == "some updated title"
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_position(position, @invalid_attrs)
      assert position == Recruit.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Recruit.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Recruit.change_position(position)
    end
  end

  describe "sub_positions" do
    alias Recruitment.Recruit.SubPosition

    @valid_attrs %{hint: "some hint", position_id: 42, status: 42, sub_title: "some sub_title"}
    @update_attrs %{hint: "some updated hint", position_id: 43, status: 43, sub_title: "some updated sub_title"}
    @invalid_attrs %{hint: nil, position_id: nil, status: nil, sub_title: nil}

    def sub_position_fixture(attrs \\ %{}) do
      {:ok, sub_position} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_sub_position()

      sub_position
    end

    test "list_sub_positions/0 returns all sub_positions" do
      sub_position = sub_position_fixture()
      assert Recruit.list_sub_positions() == [sub_position]
    end

    test "get_sub_position!/1 returns the sub_position with given id" do
      sub_position = sub_position_fixture()
      assert Recruit.get_sub_position!(sub_position.id) == sub_position
    end

    test "create_sub_position/1 with valid data creates a sub_position" do
      assert {:ok, %SubPosition{} = sub_position} = Recruit.create_sub_position(@valid_attrs)
      assert sub_position.hint == "some hint"
      assert sub_position.position_id == 42
      assert sub_position.status == 42
      assert sub_position.sub_title == "some sub_title"
    end

    test "create_sub_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_sub_position(@invalid_attrs)
    end

    test "update_sub_position/2 with valid data updates the sub_position" do
      sub_position = sub_position_fixture()
      assert {:ok, sub_position} = Recruit.update_sub_position(sub_position, @update_attrs)
      assert %SubPosition{} = sub_position
      assert sub_position.hint == "some updated hint"
      assert sub_position.position_id == 43
      assert sub_position.status == 43
      assert sub_position.sub_title == "some updated sub_title"
    end

    test "update_sub_position/2 with invalid data returns error changeset" do
      sub_position = sub_position_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_sub_position(sub_position, @invalid_attrs)
      assert sub_position == Recruit.get_sub_position!(sub_position.id)
    end

    test "delete_sub_position/1 deletes the sub_position" do
      sub_position = sub_position_fixture()
      assert {:ok, %SubPosition{}} = Recruit.delete_sub_position(sub_position)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_sub_position!(sub_position.id) end
    end

    test "change_sub_position/1 returns a sub_position changeset" do
      sub_position = sub_position_fixture()
      assert %Ecto.Changeset{} = Recruit.change_sub_position(sub_position)
    end
  end

  describe "result_classifications" do
    alias Recruitment.Recruit.ResultClassification

    @valid_attrs %{classification: "some classification", status: 42}
    @update_attrs %{classification: "some updated classification", status: 43}
    @invalid_attrs %{classification: nil, status: nil}

    def result_classification_fixture(attrs \\ %{}) do
      {:ok, result_classification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recruit.create_result_classification()

      result_classification
    end

    test "list_result_classifications/0 returns all result_classifications" do
      result_classification = result_classification_fixture()
      assert Recruit.list_result_classifications() == [result_classification]
    end

    test "get_result_classification!/1 returns the result_classification with given id" do
      result_classification = result_classification_fixture()
      assert Recruit.get_result_classification!(result_classification.id) == result_classification
    end

    test "create_result_classification/1 with valid data creates a result_classification" do
      assert {:ok, %ResultClassification{} = result_classification} = Recruit.create_result_classification(@valid_attrs)
      assert result_classification.classification == "some classification"
      assert result_classification.status == 42
    end

    test "create_result_classification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recruit.create_result_classification(@invalid_attrs)
    end

    test "update_result_classification/2 with valid data updates the result_classification" do
      result_classification = result_classification_fixture()
      assert {:ok, result_classification} = Recruit.update_result_classification(result_classification, @update_attrs)
      assert %ResultClassification{} = result_classification
      assert result_classification.classification == "some updated classification"
      assert result_classification.status == 43
    end

    test "update_result_classification/2 with invalid data returns error changeset" do
      result_classification = result_classification_fixture()
      assert {:error, %Ecto.Changeset{}} = Recruit.update_result_classification(result_classification, @invalid_attrs)
      assert result_classification == Recruit.get_result_classification!(result_classification.id)
    end

    test "delete_result_classification/1 deletes the result_classification" do
      result_classification = result_classification_fixture()
      assert {:ok, %ResultClassification{}} = Recruit.delete_result_classification(result_classification)
      assert_raise Ecto.NoResultsError, fn -> Recruit.get_result_classification!(result_classification.id) end
    end

    test "change_result_classification/1 returns a result_classification changeset" do
      result_classification = result_classification_fixture()
      assert %Ecto.Changeset{} = Recruit.change_result_classification(result_classification)
    end
  end
end
