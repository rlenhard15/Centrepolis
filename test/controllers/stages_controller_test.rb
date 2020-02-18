require 'test_helper'

class StagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stage = stages(:one)
  end

  test "should get index" do
    get stages_url, as: :json
    assert_response :success
  end

  test "should create stage" do
    assert_difference('Stage.count') do
      post stages_url, params: { stage: { category_id: @stage.category_id, title: @stage.title } }, as: :json
    end

    assert_response 201
  end

  test "should show stage" do
    get stage_url(@stage), as: :json
    assert_response :success
  end

  test "should update stage" do
    patch stage_url(@stage), params: { stage: { category_id: @stage.category_id, title: @stage.title } }, as: :json
    assert_response 200
  end

  test "should destroy stage" do
    assert_difference('Stage.count', -1) do
      delete stage_url(@stage), as: :json
    end

    assert_response 204
  end
end
