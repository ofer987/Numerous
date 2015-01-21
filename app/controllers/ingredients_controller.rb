class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]
  before_action :set_recipe

  # GET /ingredients
  def index
    @ingredients = @recipe.ingredients
  end

  # GET /ingredients/1
  def show
  end

  # GET /ingredients/new
  def new
    @ingredient = @recipe.ingredients.new
  end

  # GET /ingredients/1/edit
  def edit
  end

  # POST /ingredients
  def create
    @ingredient = @recipe.ingredients.build(ingredient_params)

    if @ingredient.save
      redirect_to [@recipe, @ingredient],
        notice: 'Ingredient was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /ingredients/1
  def update
    if @ingredient.update(ingredient_params)
      redirect_to [@recipe, @ingredient],
        notice: 'Ingredient was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /ingredients/1
  def destroy
    @ingredient.destroy
    redirect_to recipe_ingredients_url(@recipe),
      notice: 'Ingredient was successfully destroyed.'
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity, :recipe_id)
  end
end
