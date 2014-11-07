require 'json'

class ExportGraphJson
  attr_reader :vwservice, :graphservice, :currtrans


  def initialize
    @vwservice = ViewService.new
    @graphservice = GraphingService.new
    @currtrans = Emailtrans.create(comment:Time.now.strftime("%d/%m/%Y %H:%M"))
  end

  def generatejson
    generatemainjson
    generateprofilejson
    generateimagechart
    generateuserimagechart
  end

  def generateuserimagechart
    UserProfile.find_each do |userprofile|
      userprofile.profilesearchparams.find_each do |searchp|
        system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__volyr_#{searchp.id}.json volyr_#{searchp.id}_#{@currtrans.id}.png")
        system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__avgpcyr_#{searchp.id}.json avgpcyr_#{searchp.id}_#{@currtrans.id}.png")
        system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__soldyr_#{searchp.id}.json soldyr_#{searchp.id}_#{@currtrans.id}.png")

      end
    end
  end

  def generateimagechart
    system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__avgyr.json chartdat_#{@currtrans.id}.png")
    system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__volyr.json chartdatvol_#{@currtrans.id}.png")
    system("sh #{Rails.root}/highchart/exporting-server/phantomjs/phantomjs.sh #{Rails.root} #{@currtrans.id}__volsalesold.json chartdatsale_#{@currtrans.id}.png")

  rescue StandardError => e
    Rails.logger.debug 'Error running ExportGraphJson.generateimagechart ' + e.message
  end


  def generatemainjson
    volcnty = @graphservice.fndavgprcmthyr

    cats = {:categories => volcnty.category}
    icnt = 0
    vdata = Array.new
    volcnty.series.each do |volitm|
      vdata << Hash(:name => volcnty.arrseries[icnt], :data => volitm)
      icnt+=1
    end

    types = {:type => "line"}
    yax = {:title => {:text => "Average Asking Price"}}

    graphdat = {:chart => types,:title => "Average Asking Price over the year",:xAxis => cats,:yAxis => yax, :series => vdata}

    File.open("#{Rails.root}/highchart/exporting-server/phantomjs/#{@currtrans.id}__avgyr.json", "w") { |f| f.write(graphdat.to_json) }

    volmth = @graphservice.fndvolmthyr
    cats = {:categories => volmth.category}

    icnt = 0
    vdatavol = Array.new
    volmth.series.each do |volitm|
      vdatavol << Hash(:name => volmth.arrseries[icnt], :data => volitm)
      icnt+=1
    end

    types = {:type => "line"}
    yax = {:title => {:text => "Volume"}}

    graphvolsale = {:chart => types,:title => "Annual Volume Sales",:xAxis => cats,:yAxis => yax, :series => vdatavol}
    File.open("#{Rails.root}/highchart/exporting-server/phantomjs/#{@currtrans.id}__volyr.json", "w") { |f| f.write(graphvolsale.to_json) }

    volsalesold = @graphservice.fndvolcntysimple
    cats = {:categories => volsalesold.category}

    icnt = 0
    vdatasale = Array.new
    volsalesold.series.each do |volitm|
      vdatasale << Hash(:name => volsalesold.arrseries[icnt], :data => volitm)
      icnt+=1
    end

    types = {:type => "column"}
    yax = {:title => {:text => "Volume"}}

    graphvolsalesold = {:chart => types,:title => "Annual Volume Sales/Sold",:xAxis => cats,:yAxis => yax, :series => vdatasale}
    File.open("#{Rails.root}/highchart/exporting-server/phantomjs/#{@currtrans.id}__volsalesold.json", "w") { |f| f.write(graphvolsalesold.to_json) }


  rescue StandardError => e
    Rails.logger.debug 'Error running ExportGraphJson.generatemainjson ' + e.message
  end


  def generatelnGraph(vrecinput, pytitle,ptitle,pjson)

    cats = {:categories => vrecinput.category}
    icnt = 0
    vdatavol = Array.new
    vrecinput.series.each do |volitm|
      vdatavol << Hash(:name => vrecinput.arrseries[icnt], :data => volitm)
      icnt+=1
    end

    types = {:type => "line"}
    yax = {:title => {:text => pytitle}}

    graphvolsale = {:chart => types,:title => ptitle,:xAxis => cats,:yAxis => yax, :series => vdatavol}
    File.open("#{Rails.root}/highchart/exporting-server/phantomjs/#{@currtrans.id}__#{pjson}.json", "w") { |f| f.write(graphvolsale.to_json) }
  rescue StandardError => e
    Rails.logger.debug 'Error running ExportGraphJson.generatelngraph ' + e.message
  end

  def generateprofilejson
    UserProfile.find_each do |userprofile|
      userprofile.profilesearchparams.find_each do |searchp|
        prccnty = @vwservice.fndavgareaprcmthyr(searchp.id)
        generatelnGraph(prccnty,'Price', 'Average Price PropertyType',"avgpcyr_#{searchp.id}")
        volareacnty = @vwservice.fndavgareavolmthyr(searchp.id)
        generatelnGraph(volareacnty,'Volume','Annual Volume Sales',"volyr_#{searchp.id}")
        soldcnty = @vwservice.fndavgareasldmthyr(searchp.id)
        generatelnGraph(soldcnty,'Volume','Volume Sold by PropertyType',"soldyr_#{searchp.id}")

      end
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running ExportGraphJson.generateprofilejson ' + e.message
  end

end