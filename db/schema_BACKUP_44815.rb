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

ActiveRecord::Schema.define(version: 20150616233546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "administrators", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_settings", force: :cascade do |t|
    t.boolean  "require_general_invitations",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_promo_code",            default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.text     "question"
    t.string   "status",                               limit: 255
    t.integer  "turnaround_time"
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignee_id"
    t.datetime "received_at"
    t.text     "custom_response_text"
    t.boolean  "intervention_response",                            default: false
    t.text     "background"
    t.text     "relevant_prescribing_info"
    t.text     "researchable_question"
    t.text     "background_references"
    t.text     "relevant_prescribing_info_references"
  end

  add_index "inquiries", ["assignee_id"], name: "index_inquiries_on_assignee_id", using: :btree
  add_index "inquiries", ["submitter_id"], name: "index_inquiries_on_submitter_id", using: :btree

  create_table "interventions", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "inquiry_id"
    t.boolean  "taken"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interventions", ["inquiry_id"], name: "index_interventions_on_inquiry_id", using: :btree
  add_index "interventions", ["submitter_id"], name: "index_interventions_on_submitter_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "token",           limit: 255, null: false
    t.string   "email",           limit: 255, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_type", limit: 255
  end

  create_table "patients", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patients", ["user_id"], name: "index_patients_on_user_id", using: :btree

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_token", limit: 255
    t.integer  "last_four_digits"
    t.integer  "plan_id"
    t.integer  "referrer_id"
    t.string   "coupon_code",           limit: 255
  end

  add_index "payment_accounts", ["plan_id"], name: "index_payment_accounts_on_plan_id", using: :btree
  add_index "payment_accounts", ["referrer_id"], name: "index_payment_accounts_on_referrer_id", using: :btree
  add_index "payment_accounts", ["user_id"], name: "index_payment_accounts_on_user_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.integer  "price_in_cents",             null: false
    t.string   "interval",       limit: 255, null: false
    t.string   "description",    limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["name"], name: "index_plans_on_name", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                      limit: 255, null: false
    t.integer  "a_la_carte_price_in_cents",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name",   limit: 255
    t.string   "middle_name",  limit: 255
    t.string   "last_name",    limit: 255
    t.string   "name_suffix",  limit: 255
    t.string   "name_title",   limit: 255
    t.string   "company",      limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "phone_number", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["phone_number"], name: "index_profiles_on_phone_number", unique: true, using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "license_number",  limit: 255,                 null: false
    t.boolean  "verified",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "licensing_state", limit: 255
    t.string   "specialty",       limit: 255
  end

  add_index "providers", ["user_id"], name: "index_providers_on_user_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_assign",       default: true
    t.datetime "last_auto_assign"
    t.boolean  "is_alumn",         default: false
    t.boolean  "is_active"
  end

  add_index "students", ["can_assign"], name: "index_students_on_can_assign", using: :btree
  add_index "students", ["is_alumn"], name: "index_students_on_is_alumn", using: :btree
  add_index "students", ["last_auto_assign"], name: "index_students_on_last_auto_assign", using: :btree
  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "summary_tables", force: :cascade do |t|
    t.integer  "inquiry_id"
    t.integer  "responder_id"
    t.text     "notes"
    t.boolean  "complete",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "body"
    t.text     "references"
    t.text     "dropbox_url"
  end

  add_index "summary_tables", ["inquiry_id"], name: "index_summary_tables_on_inquiry_id", using: :btree
  add_index "summary_tables", ["responder_id"], name: "index_summary_tables_on_responder_id", using: :btree

  create_table "survey_responses", force: :cascade do |t|
    t.boolean  "appropriate"
    t.integer  "rating"
    t.integer  "recommendation_likelihood"
    t.string   "workflow_state",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responder_id"
    t.boolean  "initial"
  end

  add_index "survey_responses", ["responder_id"], name: "index_survey_responses_on_responder_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer "payment_account_id"
    t.string  "name"
    t.boolean "active",             default: true, null: false
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

  create_table "topic_searches", force: :cascade do |t|
    t.text     "search_terms"
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "medline_plus_result"
    t.boolean  "medline_plus_query_complete",              default: false
    t.json     "guideline_gov_result"
    t.boolean  "guideline_gov_query_complete",             default: false
    t.string   "drug_name",                    limit: 255
    t.json     "daily_med_result"
    t.boolean  "daily_med_query_complete",                 default: false
    t.json     "fda_result"
    t.boolean  "fda_query_complete",                       default: false
  end

  add_index "topic_searches", ["submitter_id"], name: "index_topic_searches_on_submitter_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, null: false
    t.string   "password_digest",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.boolean  "do_not_text"
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
    t.string   "promo_code",             limit: 255
    t.integer  "team_id"
    t.datetime "last_active_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_id"], name: "index_users_on_invitation_id", using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  create_table "waitlisted_users", force: :cascade do |t|
    t.string   "email",      limit: 255, null: false
    t.boolean  "provider",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waitlisted_users", ["email"], name: "index_waitlisted_users_on_email", unique: true, using: :btree

end
