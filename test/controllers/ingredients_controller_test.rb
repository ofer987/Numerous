require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  setup do
    @ingredient = ingredients(:leche)
    @recipe = @ingredient.recipe
    @new_ingredient = {
      name: 'milk',
      description: 'white',
      quantity: '1.1 Litres'
    }
  end

  test "should get index" do
    get :index, recipe_id: @ingredient.recipe_id
    assert_response :success
    assert_not_nil assigns(:ingredients)
  end

  test "should get new" do
    get :new, recipe_id: @ingredient.recipe
    assert_response :success
  end

  test "should create ingredient" do
    assert_difference('Ingredient.count') do
      post :create, recipe_id: @recipe.id,
        ingredient: @new_ingredient
    end

    assert_redirected_to recipe_ingredient_path(@recipe.id,
                                                assigns(:ingredient))
  end

  test "should show ingredient" do
    get :show, id: @ingredient, recipe_id: @ingredient.recipe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ingredient, recipe_id: @ingredient.recipe
    assert_response :success
  end

  test "should update ingredient" do
    patch :update, id: @ingredient, recipe_id: @ingredient.recipe,
      ingredient: { name: 'new name' }
    assert_redirected_to recipe_ingredient_path(@ingredient.recipe,
                                                assigns(:ingredient))
  end

  test "should destroy ingredient" do
    assert_difference('Ingredient.count', -1) do
      delete :destroy, id: @ingredient, recipe_id: @ingredient.recipe_id
    end

    assert_redirected_to recipe_ingredients_path(@ingredient.recipe_id)
  end
end
