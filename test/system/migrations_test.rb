require "application_system_test_case"

class MigrationsTest < ApplicationSystemTestCase
  setup do
    @migration = migrations(:one)
  end

  test "visiting the index" do
    visit migrations_url
    assert_selector "h1", text: "Migrations"
  end

  test "should create migration" do
    visit migrations_url
    click_on "New migration"

    fill_in "Createbugs", with: @migration.CreateBugs
    fill_in "Deadline", with: @migration.deadline
    fill_in "Description", with: @migration.description
    fill_in "Project", with: @migration.project_id
    fill_in "Status", with: @migration.status
    fill_in "Title", with: @migration.title
    fill_in "Type", with: @migration.type
    click_on "Create Migration"

    assert_text "Migration was successfully created"
    click_on "Back"
  end

  test "should update Migration" do
    visit migration_url(@migration)
    click_on "Edit this migration", match: :first

    fill_in "Createbugs", with: @migration.CreateBugs
    fill_in "Deadline", with: @migration.deadline.to_s
    fill_in "Description", with: @migration.description
    fill_in "Project", with: @migration.project_id
    fill_in "Status", with: @migration.status
    fill_in "Title", with: @migration.title
    fill_in "Type", with: @migration.type
    click_on "Update Migration"

    assert_text "Migration was successfully updated"
    click_on "Back"
  end

  test "should destroy Migration" do
    visit migration_url(@migration)
    click_on "Destroy this migration", match: :first

    assert_text "Migration was successfully destroyed"
  end
end
