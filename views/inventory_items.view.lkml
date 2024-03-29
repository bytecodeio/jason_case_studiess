# The name of this view in Looker is "Inventory Items"
view: inventory_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: looker-onboarding.ecommerce.inventory_items
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;}

    measure:test{
      type: count_distinct
      sql: ${id} ;;

    action: {
      label: "Action Form"
      url: "https://webhook.site/be59ad50-f970-4742-82bb-bed8bda42004"
      icon_url: "https://looker.com/favicon.ico"
      form_url: "https://webhook.site/be59ad50-f970-4742-82bb-bed8bda42004"
      param: {
        name: "name string"
        value: "input data"
         }

      form_param: {
        name: "name string"
        type:  select
        label: "input data"
        option: {
          name: "name string"
          label: "possibly-localized-string"
        }
        required: yes
        description: "possibly-localized-string"
        default: "something"

      }
  }
}

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Cost" in Explore.

  dimension: cost {
    type: number
    sql: ${TABLE}.COST ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  # measure: total_cost {
  #   type: sum
  #   sql: ${cost} ;;
  # }

   measure: average_cost {
     type: average
     label: "Average Cost"
     sql: ${cost} ;;
    value_format_name: usd
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
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.PRODUCT_BRAND ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.PRODUCT_CATEGORY ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.PRODUCT_DEPARTMENT ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.PRODUCT_DISTRIBUTION_CENTER_ID ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_ID ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.PRODUCT_NAME ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.PRODUCT_RETAIL_PRICE;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.PRODUCT_SKU ;;
    link:
    {label: "test"
      url:"https://raw.githubusercontent.com/whitlock972/Custom_Visualizations/main/hello_world.js"}
  }

  dimension_group: sold {
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
    sql: ${TABLE}."SOLD_AT" ;;
  }

  measure: count_broken{
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

}
