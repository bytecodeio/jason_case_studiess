# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  measure: total_sale_price {
    type: sum
    label: "Total Sales Price"
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_cost {
    type: sum
    label: "Total Cost"
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
  }

  measure: total_gross_margin {
    type: sum
    label: "Total Gross Margin Amount"
    sql: ${gross_margin} ;;
    value_format_name: usd
    drill_fields: [products.brand, products.category,total_gross_margin]
  }



  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  measure: average_sale_price {
    type: average
    label: "Average Sales Price"
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  dimension: gross_margin {
    type: number
    label: "Gross Revenue"
    sql: ${TABLE}."SALE_PRICE"-${inventory_items.cost} ;;
  }

  measure: average_gross_margin {
    type: average
    label: "Average Gross Margin"
    sql: ${gross_margin} ;;
    value_format_name: usd

  }


  measure: total_gross_revenue {
    type: sum
    label: "Total Gross Revenue"
    sql: ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: total_returned {
    type: count_distinct
    label: "Total Returned"
    sql: ${id} ;;
    filters: [status: "Returned"]
    value_format_name: usd
  }

  measure: gross_margin_percentage {
    type: number
    label: "Gross Margin Percentage"
    sql: 1.0*(${total_gross_margin}/NULLIF(${total_gross_revenue},0)) ;;
    value_format_name: percent_2
  }


  measure: total_items {
    type: count_distinct
    label: "Total Items"
    sql: ${inventory_item_id} ;;
   }

  measure: total_users {
    type: count_distinct
    label: "Total Users"
    sql: ${user_id} ;;
  }

  measure: number_of_customers_returning {
    type: count_distinct
    label: "Number of Customers Returning Items"
    sql: ${user_id} ;;
    filters: [status: "Returned"]
  }




  measure: user_percent_returns {
    type: number
    label: "% of Users with Returns"
    sql: 1.0*(${number_of_customers_returning}/${total_users} ;;
  }

  measure: average_spend_per_customer {
    type: number
    label: "Average Spend Per Customer"
    sql: 1.0*(${total_sale_price}/${total_users}) ;;
    value_format_name: usd
    drill_fields: [users.age_tiers, users.gender, average_spend_per_customer,total_items]
  }


  measure: item_return_rate {
    type: number
    label: "Item Return Rate"
    sql: 1.0*(${total_returned}/$(${total_items}) ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
