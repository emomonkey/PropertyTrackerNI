class UserpanelController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js


  def configreport
    unless UserProfile.exists?(['name = ?', current_user.email])
      Rails.logger.debug 'Before Welcome email'
      ReportMailer.welcome_email(current_user.email).deliver
      Rails.logger.debug 'After welcome email'
    end

    @userprofile = UserProfile.find_or_create_by(name: current_user.email)
    Rails.logger.debug ' config report uprf create ' + @userprofile.name
    @email = current_user.email
    Rails.logger.debug ' config report before @areacol ' + @email
    @areacol = SearchParams.where(county:'Co.Antrim').order(:searchparam)
    Rails.logger.debug ' config report after @areacol' 
    @areasel = Array.new
    @areaitems = Array.new
    @psearchparams = @userprofile.profilesearchparams
  rescue StandardError => e
    Rails.logger.debug 'Error running userpanel_controller.configreport ' + e.message
  end



  def saveprofile


  end


  def show
    @city = City.find_by("id = ?", params[:trip][:city_id])
  end

  def update_selarea
    @areacol = SearchParams.where(county: params[:county]).order(:searchparam)
    respond_to do |format|
      format.js
    end
  end

  def clear_area
    @userprofile = UserProfile.find_by_name (current_user.email)
    @userprofile.profilesearchparams.delete_all
    @psearchparams = @userprofile.profilesearchparams
    respond_to do |format|
      format.js
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running userpanel_controller.clear_area ' + e.message
  end

  def update_area
    @userprofile = UserProfile.find_by_name (current_user.email)
    unless @userprofile.profilesearchparams.find_by_search_params_id(params[:select_area])
      @userprofile.profilesearchparams.create(search_params_id: params[:select_area])
      @psearchparams = @userprofile.profilesearchparams
      respond_to do |format|
        format.js
      end
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running userpanel_controller.update_area ' + e.message
  end


  def displayreport
  end
end
