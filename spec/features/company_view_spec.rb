require 'rails_helper'

describe 'the company view', type: :feature do
  let(:company) { Company.create(name: 'Costco') }

  describe 'phone numbers' do
    before(:each) do
      company.phone_numbers.create(number: '555-1234')
      company.phone_numbers.create(number: '555-5678')
      visit company_path(company)
    end

    it 'shows the phone numbers' do
      company.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it 'has a link to add a new phone number' do
      expect(page).to have_link('Add phone number', href: new_phone_number_path(contact_id: company.id, contact_type: 'Company'))
    end

    it 'adds a new phone number' do
      page.click_link('Add phone number')
      page.fill_in('Number', with: '555-8888')
      page.click_button('Create Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('555-8888')
    end

    it 'has links to edit phone numbers' do
      company.phone_numbers.each do |phone|
        expect(page).to have_link('edit', href: edit_phone_number_path(phone))
      end
    end

    it 'edits a phone number' do
      phone = company.phone_numbers.first
      old_number = phone.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '555-9191')
      page.click_button('Update Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('555-9191')
      expect(page).to_not have_content(old_number)
    end

    it 'deletes a phone number' do
      phone = company.phone_numbers.first
      old_number = phone.number

      first(:link, 'delete').click
      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content(old_number)
    end
  end

  describe 'email addresses' do
    before(:each) do
      company.email_addresses.create(address: 'test@example.com')
      company.email_addresses.create(address: 'another_test@example2.com')
      visit company_path(company)
    end

    it 'shows the email addresses' do
      expect(page).to have_selector('li', text: 'test@example.com')
    end

    it 'has a link to add a new email address' do
      expect(page).to have_link('Add email address', href: new_email_address_path(contact_id: company.id, contact_type: 'Company'))
    end

    it 'can create new email addresses' do
      page.click_link('Add email address')
      page.fill_in('Address', with: 'blah@blah.com')
      page.click_button('Create Email address')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('blah@blah.com')
    end

    it 'has a link to edit an email address' do
      company.email_addresses.each do |email_address|
        expect(page).to have_link('edit', href: edit_email_address_path(email_address))
      end
    end

    it 'can edit existing email addresses' do
      email = company.email_addresses.first
      old_address = email.address

      first(:link, 'edit').click
      page.fill_in('Address', with: 'blah@blah.com')
      page.click_button('Update Email address')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('blah@blah.com')
      expect(page).to_not have_content(old_address)
    end

    it 'has a link to delete an email address' do
      company.email_addresses.each do |email_address|
        expect(page).to have_link('delete', href: email_address_path(email_address))
      end
    end

    it 'can delete an email address' do
      email_address = company.email_addresses.first
      old_email_address = email_address.address

      first(:link, 'delete').click
      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content(old_email_address)
    end
  end
end
