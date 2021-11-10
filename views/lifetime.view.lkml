# view: lifetime {
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
#}

 view: lifetime {
#   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT
         user_id as user_id
         , COUNT(distinct ORDER_ID) as lifetime_orders
         , MAX(CREATED_AT) as most_recent_purchase
         ,MIN(CREATED_AT) as first_purchase
         ,SUM(SALE_PRICE) as total_revenue
       FROM order_items
       GROUP BY user_id
       ;;
   }

  dimension: user_id {
     label: "Customer ID"
     description: "Unique ID for each user that has ordered"
     type: number
     sql: ${TABLE}.user_id ;;
   }

   dimension: lifetime_orders {
      label: "Lifetime Orders"
     description: "The total number of orders for each user"
     type: number
     sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: most_recent_purchase {
    description: "The date when each user last ordered"
    label: "Most Recent Purchase"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.most_recent_purchase ;;
  }

  dimension_group: first_purchased {
    label: "First Order Date"
    type: time
    timeframes: [date, week,month,year]
    sql: ${TABLE}.first_purchase ;;
  }

  dimension: total_revenue {
    label: "Total Revenue"
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: days_from_purchase {
    label: "Days from Last Purchase"
    type: number
    sql: DATEDIFF(day,${most_recent_purchase_date},CURRENT_DATE()) ;;
  }

  measure: average_days_from_purchase {
    label: "Average Number of Days from last puchase"
    type: average
    sql: ${days_from_purchase} ;;
  }


  dimension: is_active {
    description: "Customer is considered active if a purchase has been made in the last 90 days"
    label: "Is Active"
    type: yesno
    sql: ${days_from_purchase}<=90;;
  }

  measure: average_lifetime_revenue {
    label: "Average Lifetime Revenue"
    type: average
    sql: ${total_revenue} ;;
  }

  dimension: revenue_tiers {
    label: "Revenue Tiers"
    type: tier
    tiers: [4.99,19.99,49.99,99.99,499.99,999.99]
    sql: ${total_revenue} ;;
    style: interval
  }

  measure: total_lifetime_orders {
    description: "Use this for counting lifetime orders across many users"
    label: "Lifetime Orders"
    type: sum
    sql: ${lifetime_orders} ;;
  }

  measure: average_lifetime_orders {
    description: "Average Lifetime Orders for all Customers"
    label: "Average Lifetime Orders"
    type: average
    sql: ${lifetime_orders} ;;
  }

  dimension: repeat_customer{
    label: "Repeat Customers"
    description: "Customers with more than 1 order"
    type: yesno
    sql: ${lifetime_orders}>1 ;;
    }


 }
