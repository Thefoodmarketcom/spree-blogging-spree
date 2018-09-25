require 'spec_helper'

describe "Blog Entry", :js => true do
  context "as admin user" do
    before(:each) do
      sign_in_as!(create(:admin_user))
      visit spree.admin_path

      @blog_entry = create(:blog_entry,
        :title => "First blog entry",
        :body => "Body of the blog entry.",
        :summary => "",
        :visible => true,
        :published_at => DateTime.new(2010, 3, 11))
      click_on "Blog"
    end

    context "index page" do
      it "should display blog titles" do
        page.should have_content("First blog entry")
      end
      it "should display blog published_at" do
        page.should have_content("11 Mar 2010")
      end
      it "should display blog visible" do
        page.should have_css('.icon.icon-show.text-success')
      end
    end

    it "should edit an existing blog entry" do
      within_row(1) { click_icon :edit }
      fill_in 'Title', with: 'New title'
      fill_in 'Body', with: 'New body'
      fill_in 'Tags', with: 'tag1, tag2'
      fill_in 'Categories', with: 'cat1, cat2'
      fill_in 'Summary', with: 'New summary'
      check 'Visible'
      fill_in 'Published at', with: '2013/2/1'
      fill_in 'Permalink', with: 'some-permalink-path'
      click_on 'Update'

      page.should have_content("Blog Entry has been successfully updated")

      page.should have_content("New body")
      page.should have_content("New summary")
      find_field('blog_entry_title').value.should == "New title"
      find_field('blog_entry_tag_list').value.should == "tag1, tag2"
      find_field('blog_entry_category_list').value.should == "cat1, cat2"
      find_field('blog_entry_published_at').value.should == "2013/02/01"
      find_field('blog_entry_visible').value.should == "1"
      find_field('blog_entry_permalink').value.should == "some-permalink-path"
    end

    it "should add an author to a blog entry" do
      user = create(:user, :email => "me@example.com")
      user.spree_roles << Spree::Role.find_or_create_by(name: 'blogger')
      within_row(1) { click_icon :edit }
      select "me@example.com", :from => 'Author'
      click_on 'Update'
      page.should have_content("Blog Entry has been successfully updated")
      page.should have_content("me@example.com")
      find_field('blog_entry_author_id').value.should == user.id.to_s
    end

    it "should add a featured image to a blog entry" do
      file_name = 'image.png'
      file_path = Rails.root + "../../spec/support/#{file_name}"
      file_alt = 'image alt text'

      within_row(1) { click_icon :edit }
      attach_file('blog_entry_blog_entry_image_attributes_attachment', file_path)
      click_button "Update"

      expect(page).to have_content("successfully updated")
      expect(page).to have_css("img[src*='#{file_name}']")

      fill_in 'blog_entry_blog_entry_image_attributes_alt', with: file_alt
      click_button "Update"

      expect(page).to have_content("successfully updated")
      expect(page).to have_field("Alternative Text", with: file_alt)
      expect(page).to have_css("img[src*='#{file_name}']")
    end

    it "should edit an existing blog entry meta data" do
      within_row(1) { click_icon :edit }

      new_meta_description = 'New meta description'
      new_meta_keywords = 'New meta keywords'

      fill_in 'blog_entry_meta_description', with: new_meta_description
      fill_in 'blog_entry_meta_keywords', with: new_meta_keywords
      click_on 'Update'

      expect(find_field('blog_entry_meta_description').value).to eq(new_meta_description)
      expect(find_field('blog_entry_meta_keywords').value).to eq(new_meta_keywords)
    end
  end
end