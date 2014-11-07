class ReportMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user, subject: 'Welcome to My Awesome Site')
  rescue StandardError => e
    Rails.logger.debug 'Error running ReportMailer.welcome_email ' + e.message
  end


  def generateuserimagechart(user, trans_id)
    userpf = UserProfile.find_by_name(user)
    if userpf
      vAreas = Array.new
      userpf.profilesearchparams.find_each do |searchp|
        sparam = SearchParams.find_by(id:searchp.search_params_id)
        vAreas << sparam.searchparam
        attachments.inline["image_yr_#{sparam.searchparam}.jpg"] = File.read("#{Rails.root}/public/export/volyr_#{searchp.id}_#{trans_id}.png" )
        attachments.inline["avgpc_yr_#{sparam.searchparam}.jpg"] = File.read("#{Rails.root}/public/export/avgpcyr_#{searchp.id}_#{trans_id}.png" )
        attachments.inline["sold_yr_#{sparam.searchparam}.jpg"] = File.read("#{Rails.root}/public/export/soldyr_#{searchp.id}_#{trans_id}.png" )

      end
    end
    return vAreas
  rescue StandardError => e
    Rails.logger.debug 'Error running ReportMailer.generateuserimagechart ' + e.message
  end

  def displayreport(user, trans_id)
    attachments.inline['imageavgprc.jpg'] = File.read("#{Rails.root}/public/export/chartdat_#{trans_id}.png" )
    attachments.inline['imagevol.jpg'] = File.read("#{Rails.root}/public/export/chartdatvol_#{trans_id}.png" )
    attachments.inline['imagesalesold.jpg'] = File.read("#{Rails.root}/public/export/chartdatsale_#{trans_id}.png" )
    @vAreas = generateuserimagechart(user, trans_id)

    mail(to: user, subject: 'PropertyTrack NI Report')
  rescue StandardError => e
    Rails.logger.debug 'Error running ReportMailer.displayreport ' + e.message
  end

end
