ActiveRecord::Schema.define do
   create_table "videos", :force => true do |t|
     t.column "title",  :string
   end
 end