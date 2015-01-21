require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'ingredient should belong to a recipe' do
    ingredient = Ingredient.new(name: 'quinoa', quantity: '100 grams')

    refute ingredient.valid?, 'ingredient is not valid'
  end
end
