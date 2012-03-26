# Stores engine for Refinery CMS.

## *** STILL IN DEVELOPMENT ***
Please wait for v1 release! It very crudely works now with Stripe; Here's what works:

* Customer: signup, signin, signout, edit customer profile
* Stores: create, delete, edit, show stores; however, only 1 store (:is_active => true) is ever shown to customers
* The active store will always show the entire catalog (no paging yet); click name to view, click add-to-cart
* Products: create, delete, edit
* Cart: exists only within context of the session; lose the session, lose the cart
* Checkout: converts cart to proto-Order
* Orders: order state machine works; edit order, enter credit card, purchase
* Payment gateway: Stripe is default, setup keys in Settings (first time usage creates empty default secret, API); Stripe is working for purchases.
* Styling: very minimal (in RefineryCMS tradition), but fully capable of supporting fancy CSS styling

## TO-DO List ##

* shipping
* tax modes
* product variations
* related products
* digital-downloads
* discounts
* view, track orders
* product inventory add/subtract

## How to build this engine as a gem

    cd vendor/engines/stores
    gem build refinerycms-stores.gemspec
    gem install refinerycms-stores.gem

    # Sign up for a http://rubygems.org/ account and publish the gem
    gem push refinerycms-stores.gem
