view: customer_ranking {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: created_date {}
      column: inventory_item_id {}
      column: sale_price {}
      derived_column: order_sequence {
        sql:  ROW_NUMBER() OVER (PARTITION by user_id ORDER BY created_date) ;;
      }
      derived_column: lag_date {
        sql:  LAG(created_date, 1) OVER (PARTITION by user_id ORDER BY created_date) ;;
      }

    }
  }
  dimension: user_id {
    description: "This is the unique identifier of the user making the order"
    type: number
    primary_key: yes
  }

  dimension_group: created_date {
    description: "This is the date an order was created"
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
  }

  dimension: order_sequence {
    description: "This is the unique user order sequence"
    type: number
  }

  dimension_group: lag_date {
    description: "lag partitioned by user_id and ordered by craeted date"
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
  }

  dimension: inventory_item_id {
    description: "This is the unique ID of ordered item in inventory"
    type: number
  }

  dimension: sale_price {
    description: "This is the sales cost of that order item"
    type: number
    value_format_name: usd
  }

# Active: Computing Duration of orders to be delivered
  dimension_group: days_between_orders {
    description: "The number of days between when a customer ordered items"
    type:  duration
    intervals: [day]
    sql_start:  ${lag_date_date};;
    sql_end: ${created_date_date};;
  }

  dimension: is_first_purchase {
    description: "Identifies whether it is a users first purchase"
    type:  yesno
    sql: ${order_sequence} = 1 ;;
  }

  dimension:is_repeat{
    type: yesno
    description: "Has the customer ordered more than one time"
    sql: ${order_sequence} > 1 ;;
  }

  measure: average_days_between_orders {
    type: average
    sql: round(${days_days_between_orders},0) ;;
  }

  measure: smallest_order_duration {
    type: min
    sql: ${days_days_between_orders} ;;
  }

  measure: sum_sales_price {
    description:"sum of sales price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

}
