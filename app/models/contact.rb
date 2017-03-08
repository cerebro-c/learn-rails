require 'google_drive'
class Contact < ActiveRecord::Base
	has_no_table

	attr_accessor :name, :string
	attr_accessor :email, :string
	attr_accessor :content, :string

	validates_presence_of :name
	validates_presence_of :email
	validates_presence_of :content

	validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
	validates_length_of :content, :maximum => 500

	def update_spreadsheet

		connection = GoogleDrive.login_with_oauth(new_access_token)
		ss = connection.spreadsheet_by_title("Learn-Rails-Example")

		if ss.nil?
			ss = connection.create_spreadsheet("Learn-Rails-Example")
		end

		ws = ss.worksheets[0]
		last_row = 1 + ws.num_rows
		ws[last_row, 1] = Time.new
		ws[last_row, 2] = self.name
		ws[last_row, 3] = self.email
		ws[last_row, 4] = self.content
		ws.save

	end

	def new_access_token
	  # Authorizes with OAuth and gets an access token.
		client = GoogleDrive::APIClient.new
		auth = client.authorization
		auth.client_id = "manueleuclides22@gmail.com"
		auth.client_secret = "criado1992"
		auth.scope =
		    "https://www.googleapis.com/auth/drive " +
		    "https://spreadsheets.google.com/feeds/"
		auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
		print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
		print("2. Enter the authorization code shown in the page: ")
		auth.code = $stdin.gets.chomp
		auth.fetch_access_token!
		access_token = auth.access_token
	  	access_token # this line important, returning access_token
	end
end