# frozen_string_literal: true

<<<<<<< HEAD
# frozen_string_literal: true

# Pagy initializer file (2.1.5)
# Customize only what you really need and notice that Pagy works also without any of the following lines.
# Should you just cherry pick part of this file, please maintain the require-order of the extras

=======
# Pagy initializer file (5.10.1)
# Customize only what you really need and notice that the core Pagy works also without any of the following lines.
# Should you just cherry pick part of this file, please maintain the require-order of the extras

# Pagy DEFAULT Variables
# See https://ddnexus.github.io/pagy/api/pagy#variables
# All the Pagy::DEFAULT are set for all the Pagy instances but can be overridden per instance by just passing them to
# Pagy.new|Pagy::Countless.new|Pagy::Calendar::*.new or any of the #pagy* controller methods

# Instance variables
# See https://ddnexus.github.io/pagy/api/pagy#instance-variables
# Pagy::DEFAULT[:page]   = 1                                  # default
Pagy::DEFAULT[:items] = 10 # default
# Pagy::DEFAULT[:outset] = 0                                  # default

# Other Variables
# See https://ddnexus.github.io/pagy/api/pagy#other-variables
# Pagy::DEFAULT[:size]       = [1,4,4,1]                       # default
# Pagy::DEFAULT[:page_param] = :page                           # default
# The :params can be also set as a lambda e.g ->(params){ params.exclude('useless').merge!('custom' => 'useful') }
# Pagy::DEFAULT[:params]     = {}                              # default
# Pagy::DEFAULT[:fragment]   = '#fragment'                     # example
# Pagy::DEFAULT[:link_extra] = 'data-remote="true"'            # example
# Pagy::DEFAULT[:i18n_key]   = 'pagy.item_name'                # default
# Pagy::DEFAULT[:cycle]      = true                            # example

>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
# Extras
# See https://ddnexus.github.io/pagy/extras

# Backend Extras

# Array extra: Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
# See https://ddnexus.github.io/pagy/extras/array
require 'pagy/extras/array'

<<<<<<< HEAD
# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/extras/countless
# require 'pagy/extras/countless'
# Pagy::VARS[:cycle] = false    # default

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects
# See https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# require 'pagy/extras/elasticsearch_rails'

# Searchkick extra: Paginate `Searchkick::Results` objects
# See https://ddnexus.github.io/pagy/extras/searchkick
# require 'pagy/extras/searchkick'

# Frontend Extras

# Bootstrap extra: Add nav, responsive and compact helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/extras/bootstrap
require 'pagy/extras/bootstrap'

# Bulma extra: Add nav, responsive and compact helpers and templates for Bulma pagination
# See https://ddnexus.github.io/pagy/extras/bulma
# require 'pagy/extras/bulma'

# Foundation extra: Add nav, responsive and compact helpers and templates for Foundation pagination
# See https://ddnexus.github.io/pagy/extras/foundation
# require 'pagy/extras/foundation'

# Materialize extra: Nav, responsive and compact helpers for Materialize pagination
# See https://ddnexus.github.io/pagy/extras/materialize
# require 'pagy/extras/materialize'

# Plain extra: Add responsive and compact nav plain helpers
# Notice: the other frontend extras add their own framework-styled versions,
# so require this extra only if you need the plain unstyled version
# See https://ddnexus.github.io/pagy/extras/plain
# require 'pagy/extras/plain'

# Semantic extra: Nav, responsive and compact helpers for Semantic UI pagination
# See https://ddnexus.github.io/pagy/extras/semantic
# require 'pagy/extras/semantic'

# Breakpoints var used by the responsive nav helpers
# See https://ddnexus.github.io/pagy/extras/plain#breakpoints
# Pagy::VARS[:breakpoints] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }

# Feature Extras

# Headers extra: http response headers (and other helpers) useful for API pagination
# See http://ddnexus.github.io/pagy/extras/headers
# require 'pagy/extras/headers'
# Pagy::VARS[:headers] = { page: 'Current-Page', items: 'Page-Items',
#                          count: 'Total-Count', pages: 'Total-Pages' }     # default
=======
# Calendar extra: Add pagination filtering by calendar time unit (year, quarter, month, week, day)
# See https://ddnexus.github.io/pagy/extras/calendar
# require 'pagy/extras/calendar'
# Default for each unit
# Pagy::Calendar::Year::DEFAULT[:order]     = :asc        # Time direction of pagination
# Pagy::Calendar::Year::DEFAULT[:format]    = '%Y'        # strftime format
#
# Pagy::Calendar::Quarter::DEFAULT[:order]  = :asc        # Time direction of pagination
# Pagy::Calendar::Quarter::DEFAULT[:format] = '%Y-Q%q'    # strftime format
#
# Pagy::Calendar::Month::DEFAULT[:order]    = :asc        # Time direction of pagination
# Pagy::Calendar::Month::DEFAULT[:format]   = '%Y-%m'     # strftime format
#
# Pagy::Calendar::Week::DEFAULT[:order]     = :asc        # Time direction of pagination
# Pagy::Calendar::Week::DEFAULT[:format]    = '%Y-%W'     # strftime format
#
# Pagy::Calendar::Day::DEFAULT[:order]      = :asc        # Time direction of pagination
# Pagy::Calendar::Day::DEFAULT[:format]     = '%Y-%m-%d'  # strftime format
#
# Uncomment the following lines, if you need calendar localization without using the I18n extra
# module LocalizePagyCalendar
#   def localize(time, opts)
#     ::I18n.l(time, **opts)
#   end
# end
# Pagy::Calendar.prepend LocalizePagyCalendar

# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/extras/countless
# require 'pagy/extras/countless'
# Pagy::DEFAULT[:countless_minimal] = false   # default (eager loading)

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects
# See https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# Default :pagy_search method: change only if you use also
# the searchkick or meilisearch extra that defines the same
# Pagy::DEFAULT[:elasticsearch_rails_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:elasticsearch_rails_search] = :search
# require 'pagy/extras/elasticsearch_rails'

# Headers extra: http response headers (and other helpers) useful for API pagination
# See http://ddnexus.github.io/pagy/extras/headers
# require 'pagy/extras/headers'
# Pagy::DEFAULT[:headers] = { page: 'Current-Page',
#                            items: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# Meilisearch extra: Paginate `Meilisearch` result objects
# See https://ddnexus.github.io/pagy/extras/meilisearch
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or searchkick extra that define the same method
# Pagy::DEFAULT[:meilisearch_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:meilisearch_search] = :ms_search
# require 'pagy/extras/meilisearch'

# Metadata extra: Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
# See https://ddnexus.github.io/pagy/extras/metadata
# you must require the shared internal extra (BEFORE the metadata extra) ONLY if you need also the :sequels
# require 'pagy/extras/shared'
require 'pagy/extras/metadata'
# For performance reasons, you should explicitly set ONLY the metadata you use in the frontend
# Pagy::DEFAULT[:metadata] = %i[scaffold_url page prev next last]   # example

# Searchkick extra: Paginate `Searchkick::Results` objects
# See https://ddnexus.github.io/pagy/extras/searchkick
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or meilisearch extra that defines the same
# DEFAULT[:searchkick_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:searchkick_search] = :search
# require 'pagy/extras/searchkick'
# uncomment if you are going to use Searchkick.pagy_search
# Searchkick.extend Pagy::Searchkick

# Frontend Extras

# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/extras/bootstrap
require 'pagy/extras/bootstrap'

# Bulma extra: Add nav, nav_js and combo_nav_js helpers and templates for Bulma pagination
# See https://ddnexus.github.io/pagy/extras/bulma
# require 'pagy/extras/bulma'

# Foundation extra: Add nav, nav_js and combo_nav_js helpers and templates for Foundation pagination
# See https://ddnexus.github.io/pagy/extras/foundation
# require 'pagy/extras/foundation'

# Materialize extra: Add nav, nav_js and combo_nav_js helpers for Materialize pagination
# See https://ddnexus.github.io/pagy/extras/materialize
# require 'pagy/extras/materialize'

# Navs extra: Add nav_js and combo_nav_js javascript helpers
# Notice: the other frontend extras add their own framework-styled versions,
# so require this extra only if you need the unstyled version
# See https://ddnexus.github.io/pagy/extras/navs
# require 'pagy/extras/navs'

# Semantic extra: Add nav, nav_js and combo_nav_js helpers for Semantic UI pagination
# See https://ddnexus.github.io/pagy/extras/semantic
# require 'pagy/extras/semantic'

# UIkit extra: Add nav helper and templates for UIkit pagination
# See https://ddnexus.github.io/pagy/extras/uikit
# require 'pagy/extras/uikit'

# Multi size var used by the *_nav_js helpers
# See https://ddnexus.github.io/pagy/extras/navs#steps
# Pagy::DEFAULT[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }   # example

# Feature Extras

# Gearbox extra: Automatically change the number of items per page depending on the page number
# See https://ddnexus.github.io/pagy/extras/gearbox
# require 'pagy/extras/gearbox'
# set to false only if you want to make :gearbox_extra an opt-in variable
# Pagy::DEFAULT[:gearbox_extra] = false               # default true
# Pagy::DEFAULT[:gearbox_items] = [15, 30, 60, 100]   # default

# Items extra: Allow the client to request a custom number of items per page with an optional selector UI
# See https://ddnexus.github.io/pagy/extras/items
# require 'pagy/extras/items'
# set to false only if you want to make :items_extra an opt-in variable
# Pagy::DEFAULT[:items_extra] = false    # default true
# Pagy::DEFAULT[:items_param] = :items   # default
# Pagy::DEFAULT[:max_items]   = 100      # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/extras/overflow
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page # default  (other options: :last_page and :exception)
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8

# Support extra: Extra support for features like: incremental, infinite, auto-scroll pagination
# See https://ddnexus.github.io/pagy/extras/support
# require 'pagy/extras/support'

<<<<<<< HEAD
# Items extra: Allow the client to request a custom number of items per page with an optional selector UI
# See https://ddnexus.github.io/pagy/extras/items
# require 'pagy/extras/items'
# Pagy::VARS[:items_param] = :items    # default
# Pagy::VARS[:max_items]   = 100       # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/extras/overflow
require 'pagy/extras/overflow'
# Pagy::VARS[:overflow] = :empty_page    # default  (other options: :last_page and :exception)
Pagy::VARS[:overflow] = :last_page
# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/extras/trim
# require 'pagy/extras/trim'

# Pagy Variables
# See https://ddnexus.github.io/pagy/api/pagy#variables
# All the Pagy::VARS are set for all the Pagy instances but can be overridden
# per instance by just passing them to Pagy.new or the #pagy controller method

# Instance variables
# See https://ddnexus.github.io/pagy/api/pagy#instance-variables
Pagy::VARS[:items] = Rails.configuration.pagination_rows # default

# Other Variables
# See https://ddnexus.github.io/pagy/api/pagy#other-variables
# Pagy::VARS[:size]       = [1,4,4,1]                       # default
# Pagy::VARS[:page_param] = :page                           # default
# Pagy::VARS[:params]     = {}                              # default
# Pagy::VARS[:anchor]     = '#anchor'                       # example
# Pagy::VARS[:link_extra] = 'data-remote="true"'            # example
# Pagy::VARS[:item_path]  = 'activerecord.models.product'   # example

# Rails

# Rails: extras assets path required by the compact and responsive navs, and the items extra
# See https://ddnexus.github.io/pagy/extras#javascript
=======
# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/extras/trim
# require 'pagy/extras/trim'
# set to false only if you want to make :trim_extra an opt-in variable
# Pagy::DEFAULT[:trim_extra] = false # default true

# Standalone extra: Use pagy in non Rack environment/gem
# See https://ddnexus.github.io/pagy/extras/standalone
# require 'pagy/extras/standalone'
# Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'  # optional default

# Rails
# Enable the .js file required by the helpers that use javascript
# (pagy*_nav_js, pagy*_combo_nav_js, and pagy_items_selector_js)
# See https://ddnexus.github.io/pagy/extras#javascript

# With the asset pipeline
# Sprockets need to look into the pagy javascripts dir, so add it to the assets paths
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
# Rails.application.config.assets.paths << Pagy.root.join('javascripts')

# I18n

# Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# See https://ddnexus.github.io/pagy/api/frontend#i18n
# Notice: No need to configure anything in this section if your app uses only "en"
# or if you use the i18n extra below
#
# Examples:
# load the "de" built-in locale:
# Pagy::I18n.load(locale: 'de')
#
# load the "de" locale defined in the custom file at :filepath:
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# load the "de", "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
<<<<<<< HEAD
# Pagy::I18n.load({locale: 'de'},
#                 {locale: 'en'},
#                 {locale: 'es'})
=======
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
#
# load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
<<<<<<< HEAD
# Pagy::I18n.load({locale: 'en'},
#                 {locale: 'es', filepath: 'path/to/pagy-es.yml'},
#                 {locale: 'xyz',  # not built-in
#                  filepath: 'path/to/pagy-xyz.yml',
#                  pluralize: lambda{|count| ... } )
=======
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8

# I18n extra: uses the standard i18n gem which is ~18x slower using ~10x more memory
# than the default pagy internal i18n (see above)
# See https://ddnexus.github.io/pagy/extras/i18n
<<<<<<< HEAD
require 'pagy/extras/i18n'
=======
# require 'pagy/extras/i18n'

# Default i18n key
# Pagy::DEFAULT[:i18n_key] = 'pagy.item_name'   # default

# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy::DEFAULT.freeze
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
