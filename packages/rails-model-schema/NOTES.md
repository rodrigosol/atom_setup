```ruby
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150820170637) do
  create_table "comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
```

```coffee
SCHEMA_DEF_REGEXP = /ActiveRecord::Schema.define\(version: [\d]+\) do/
TABLE_DEF_REGEXP = /create_table "comments"[\w\W]+ do \|t\|/
COLUMN_DEF_REGEXP = /\bt.([a-zA-Z_]+)[\W]+"([a-zA-Z_]+)"[^\n]*/

columns = []
schema_found = false
table_found = false

for line in lines
  if SCHEMA_DEF_REGEXP.test(line)
    schema_found = true
  else if schema_found
    if TABLE_DEF_REGEXP.test(line)
      table_found = true
    else if table_found
      if matches = COLUMN_DEF_REGEXP.exec(line)
        columns.push(type: matches[0], name: matches[1])
      else if END_OF_BLOCK.test(line)
        table_found = false
```
