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

ActiveRecord::Schema.define(version: 20170328121908) do

  create_table "comptes", force: :cascade do |t|
    t.string  "nom"
    t.integer "user_id"
    t.string  "titre_espace", default: "Mon Silo"
    t.index ["user_id"], name: "index_comptes_on_user_id"
  end

  create_table "desks", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.string   "route",      limit: 20
    t.boolean  "publish"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "compte_id"
    t.index ["compte_id"], name: "index_desks_on_compte_id"
  end

  create_table "draws", force: :cascade do |t|
    t.string   "name",       limit: 25
    t.string   "route",      limit: 25
    t.boolean  "publish"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "desk_id"
    t.index ["desk_id"], name: "index_draws_on_desk_id"
  end

  create_table "fiches", force: :cascade do |t|
    t.string   "name"
    t.string   "route"
    t.string   "type"
    t.boolean  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "draw_id"
    t.index ["draw_id"], name: "index_fiches_on_draw_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "ref"
    t.string "nom"
  end

  create_table "layouts", force: :cascade do |t|
    t.string "ref"
    t.string "margin"
    t.string "minwidth"
    t.string "radius"
  end

  create_table "palettes", force: :cascade do |t|
    t.string "ref"
    t.string "c1"
    t.string "c2"
    t.string "c3"
    t.string "c4"
    t.string "c5"
  end

  create_table "polices", force: :cascade do |t|
    t.string "ref"
    t.string "nom"
  end

  create_table "preferences", force: :cascade do |t|
    t.string  "polices"
    t.string  "img_header"
    t.string  "color1"
    t.string  "color2"
    t.string  "color3"
    t.string  "color4"
    t.string  "color5"
    t.string  "layout"
    t.integer "compte_id"
    t.index ["compte_id"], name: "index_preferences_on_compte_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "nom"
    t.string   "identifiant_eleve"
    t.integer  "is_admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["identifiant_eleve"], name: "index_users_on_identifiant_eleve", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
