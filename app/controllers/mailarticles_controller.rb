class MailarticlesController <  ApplicationController

  before_action :authenticate_admin!

  def list
    @Mailarticles = Mailarticle.all
  end

  def new

  end

  def create
    @Mailarticle = Mailarticle.new(mailarticle_params)

    @Mailarticle.save
    redirect_to  :action => 'list'
  end

  def show
    @Mailarticle = Mailarticle.find(params[:id])
  end

  def update
    marticle = Mailarticle.find_by(id: params[:m_id])
    marticle.update(title: mailarticle_params[:title], text: mailarticle_params[:text])


    redirect_to  :action => 'list'
  end

  def edit
    @Mailarticle = Mailarticle.find(params[:id])
  end

  private
  def mailarticle_params
    params.require(:mailarticle).permit(:m_id,:title, :text)
  end




end
