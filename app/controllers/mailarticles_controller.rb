class MailarticlesController <  ApplicationController

  before_action :authenticate_admin!

  def list
    @Mailarticles = Mailarticle.all
  end

  def new

  end

  def create
    @Mailarticle = Mailarticle.new(params[:mailarticle])

    @Mailarticle.save
    redirect_to @Mailarticle
  end

  def show
    @Mailarticle = Mailarticle.find(params[:id])
  end

  private
  def mailarticle_params
    params.require(:mailarticle).permit(:title, :text)
  end




end
