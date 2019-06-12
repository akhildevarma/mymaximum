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

ActiveRecord::Schema.define(version: 20190413032144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",       default: 3
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "application_settings", force: :cascade do |t|
    t.boolean  "require_general_invitations",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_promo_code",            default: false
  end

  create_table "blog_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "referenceable_type"
    t.integer  "referenceable_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "comment_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_udx", unique: true, using: :btree
  add_index "comment_hierarchies", ["descendant_id"], name: "comment_desc_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "body"
    t.boolean  "deleted"
    t.string   "referenceable_type"
    t.integer  "referenceable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "referenceable_type"
    t.integer  "referenceable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "status"
    t.text     "description"
    t.string   "token"
  end

  create_table "email_lists", force: :cascade do |t|
    t.string   "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fda_drug_shortages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "link"
    t.datetime "published_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flagged_comments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "comment_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flagged_comments", ["user_id", "comment_id"], name: "index_flagged_comments_on_user_id_and_comment_id", unique: true, using: :btree

  create_table "guids", force: :cascade do |t|
    t.string   "uid",                null: false
    t.string   "referenceable_type"
    t.integer  "referenceable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guids", ["referenceable_id"], name: "index_guids_on_referenceable_id", using: :btree
  add_index "guids", ["uid"], name: "index_guids_on_uid", using: :btree

  create_table "hospital_drugs", force: :cascade do |t|
    t.string   "title"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inquiries", force: :cascade do |t|
    t.text     "question"
    t.string   "status"
    t.integer  "turnaround_time"
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignee_id"
    t.datetime "received_at"
    t.text     "custom_response_text"
    t.boolean  "intervention_response",                default: false
    t.text     "background"
    t.text     "relevant_prescribing_info"
    t.text     "researchable_question"
    t.text     "background_references"
    t.text     "relevant_prescribing_info_references"
    t.text     "search_strategy"
    t.text     "dropbox_urls"
    t.datetime "overdue_notification_sent_at"
    t.datetime "completed_at"
    t.datetime "published_at"
    t.datetime "read_at"
    t.text     "review_of_clinical_guidelines"
    t.text     "review_of_meta_analyses"
    t.text     "review_of_review_articles"
    t.text     "review_of_other_tertiary_literature"
    t.boolean  "view_everyone",                        default: false
    t.text     "title"
    t.text     "slug"
    t.string   "project_types"
    t.jsonb    "hidden_sections"
    t.string   "inquiry_type",                         default: "non_blog"
    t.datetime "reopened_at"
    t.string   "doc_url"
    t.text     "level_of_evidence"
  end

  add_index "inquiries", ["assignee_id"], name: "index_inquiries_on_assignee_id", using: :btree
  add_index "inquiries", ["slug"], name: "index_inquiries_on_slug", using: :btree
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
    t.string   "token",           null: false
    t.string   "email",           null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_type"
  end

  create_table "level_of_evidences", force: :cascade do |t|
    t.string   "level"
    t.string   "treatment"
    t.string   "medicine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "referenceable_type"
    t.integer  "referenceable_id"
    t.string   "notification_type"
    t.string   "sent_via"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.boolean  "weekly_email_finished"
    t.integer  "weekly_email_status"
  end

  add_index "notifications", ["notification_type", "sent_at"], name: "index_notifications_on_notification_type_sent_at", using: :btree
  add_index "notifications", ["referenceable_type"], name: "index_notifications_on_referenceable_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

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
    t.string   "stripe_customer_token"
    t.integer  "last_four_digits"
    t.integer  "plan_id"
    t.integer  "referrer_id"
    t.string   "coupon_code"
  end

  add_index "payment_accounts", ["plan_id"], name: "index_payment_accounts_on_plan_id", using: :btree
  add_index "payment_accounts", ["referrer_id"], name: "index_payment_accounts_on_referrer_id", using: :btree
  add_index "payment_accounts", ["user_id"], name: "index_payment_accounts_on_user_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "price_in_cents", null: false
    t.string   "interval",       null: false
    t.string   "description",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["name"], name: "index_plans_on_name", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                      null: false
    t.integer  "a_la_carte_price_in_cents", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "name_title"
    t.string   "company"
    t.string   "city"
    t.string   "state"
    t.string   "phone_number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["phone_number"], name: "index_profiles_on_phone_number", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "license_number"
    t.boolean  "verified",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "licensing_state"
    t.string   "specialty"
  end

  add_index "providers", ["user_id"], name: "index_providers_on_user_id", using: :btree

  create_table "signup_trackers", force: :cascade do |t|
    t.string   "email"
    t.string   "status"
    t.integer  "notified_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_assign",       default: false
    t.datetime "last_auto_assign"
    t.boolean  "is_alumn",         default: false
    t.boolean  "is_active"
    t.boolean  "is_priority",      default: false
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
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responder_id"
    t.boolean  "initial"
    t.boolean  "intervention"
    t.text     "outcome"
    t.text     "what_was_intervention"
    t.integer  "inquiry_id"
    t.datetime "sent_feedback_at"
    t.text     "overall_experience"
  end

  add_index "survey_responses", ["created_at", "initial", "inquiry_id", "workflow_state", "sent_feedback_at"], name: "index_survey_responses_on_feedback_first", using: :btree
  add_index "survey_responses", ["inquiry_id"], name: "index_survey_responses_on_inquiry_id", using: :btree
  add_index "survey_responses", ["responder_id"], name: "index_survey_responses_on_responder_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "payment_account_id"
    t.string   "name"
    t.boolean  "active",             default: true,  null: false
    t.string   "admin_email"
    t.string   "signup_url_path"
    t.string   "email_domain"
    t.integer  "user_id"
    t.string   "logo_url"
    t.boolean  "hidden",             default: true
    t.string   "kind"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.date     "launch_date"
    t.string   "cmo_email"
    t.string   "cmo_name"
    t.string   "cmo_phone"
    t.boolean  "private_label",      default: false
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

  create_table "topic_searches", force: :cascade do |t|
    t.text     "search_terms"
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "medline_plus_result"
    t.boolean  "medline_plus_query_complete",  default: false
    t.json     "guideline_gov_result"
    t.boolean  "guideline_gov_query_complete", default: false
    t.string   "drug_name"
    t.json     "daily_med_result"
    t.boolean  "daily_med_query_complete",     default: false
    t.json     "fda_result"
    t.boolean  "fda_query_complete",           default: false
  end

  add_index "topic_searches", ["submitter_id"], name: "index_topic_searches_on_submitter_id", using: :btree

  create_table "unscriber_lists", force: :cascade do |t|
    t.string   "email"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upload_users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "first_name",      limit: 255
    t.string   "middle_name",     limit: 255
    t.string   "last_name",       limit: 255
    t.string   "name_suffix",     limit: 255
    t.string   "name_title",      limit: 255
    t.string   "company",         limit: 255
    t.string   "city",            limit: 255
    t.string   "state",           limit: 255
    t.string   "phone_number",    limit: 255
    t.string   "license_number",  limit: 255
    t.string   "licensing_state", limit: 255
    t.string   "specialty",       limit: 255
    t.string   "promo_code",      limit: 255
    t.string   "status",          limit: 100
    t.integer  "team_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "message"
  end

  add_index "upload_users", ["status"], name: "index_upload_users_on_status", using: :btree
  add_index "upload_users", ["team_id"], name: "index_upload_users_on_team_id", using: :btree

  create_table "user_emails", force: :cascade do |t|
    t.string   "email",            null: false
    t.integer  "user_id"
    t.boolean  "is_deprecated"
    t.boolean  "is_primary"
    t.string   "activation_token"
    t.datetime "activated_at"
  end

  add_index "user_emails", ["email"], name: "index_user_emails_on_email", unique: true, using: :btree

  create_table "user_preferences", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "inquiry_view_default_combined"
  end

  add_index "user_preferences", ["user_id"], name: "index_user_preferences_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                   null: false
    t.string   "password_digest",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.boolean  "do_not_text"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "promo_code"
    t.integer  "team_id"
    t.datetime "last_active_at"
    t.datetime "account_activated_at"
    t.string   "account_activation_token"
    t.boolean  "is_active",                default: true
    t.string   "remember_me_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_id"], name: "index_users_on_invitation_id", using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",           null: false
    t.integer  "item_id",             null: false
    t.string   "event",               null: false
    t.string   "whodunnit"
    t.text     "object"
    t.integer  "inquiry_assignee_id"
    t.string   "inquiry_status"
    t.datetime "created_at"
  end

  add_index "versions", ["inquiry_assignee_id"], name: "index_versions_on_inquiry_assignee_id", using: :btree
  add_index "versions", ["inquiry_status"], name: "index_versions_on_inquiry_status", using: :btree
  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "waitlisted_users", force: :cascade do |t|
    t.string   "email",      null: false
    t.boolean  "provider",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waitlisted_users", ["email"], name: "index_waitlisted_users_on_email", unique: true, using: :btree

end
