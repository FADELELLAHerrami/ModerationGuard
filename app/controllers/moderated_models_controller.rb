class ModeratedModelsController < ApplicationController

  def new
    @moderateds = ModeratedModel.new
  end

  def create

    @moderateds = ModeratedModel.new(moderated_params)

    if @moderateds.save
      # Après avoir enregistré avec succès, modérez le contenu et définissez is_accepted
      @moderateds.is_accepted
      redirect_to root_path, notice: "#{@moderateds.is_accepted}"
    else
      # Gérer le cas où l'enregistrement a échoué
      redirect_to root_path, notice: "#{@moderateds.is_accepted.class}"
    end
  end
  private
  def moderated_params
    params.require(:moderated_model).permit(:text, :language)
  end
end
