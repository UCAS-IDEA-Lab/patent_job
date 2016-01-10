require 'fastercsv'
require 'active_record'
require 'pp'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "../Patents.db"
)

class Patent < ActiveRecord::Base
end

Patent.delete_all
Patent.create(person_id: "patent_guy", name: "My patent", title: "Really nice patent")

pp Patent.all