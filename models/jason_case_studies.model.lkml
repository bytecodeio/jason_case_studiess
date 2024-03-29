# Define the database connection to be used for this model.
connection: "ecommerce"

# include all the views
include: "/views/**/*.view"

##test code

##test
# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: jason_case_studies_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
## test comment
persist_with: jason_case_studies_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Jason Case Studies"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

#explore: distribution_centers {}

#explore: etl_jobs {}

# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }
##keep only this one

##test change
explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: lifetime {
    type: left_outer
    sql_on: ${lifetime.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

  join: customer_ranking {
    type: left_outer
    sql_on: ${customer_ranking.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {}
# explore: products {
#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }
# explore: lifetime {
#   join: users {
#     type: left_outer
#     sql_on: ${lifetime.user_id} = ${users.id} ;;
#     relationship: many_to_one
#     }

#   join: order_items {
#     type: left_outer
#     sql_on: ${lifetime.user_id} = ${order_items.user_id} ;;
#     relationship: many_to_one
#     }


# }

#explore: users {}
