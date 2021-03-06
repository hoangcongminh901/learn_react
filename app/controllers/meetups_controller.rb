class MeetupsController < ApplicationController
  def new
    @technologies = Technology.all.to_a
  end

  def create
    @meetup = Meetup.new meetup_params

    respond_to do |format|
      if @meetup.save
        format.html{redirect_to @meetup, notice: "Meetup was successfully created."}
        format.json{head :ok}
      else
        format.html{render :new}
        format.json{render son: @meetup.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  def meetup_params
    params.require(:meetup).permit :title, :description, :date, :seo,
      :technology, guests: []
  end
end
