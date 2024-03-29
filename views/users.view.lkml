# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  measure: total_users {
    type: count_distinct
    sql: ${id} ;;
  }





  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: age_tiers {
    type: tier
    label: "Age Tiers"
    tiers: [15,25,50,60,66,70]
    style:integer
    sql: ${age} ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
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

  dimension: DayCheck {
    label: "Days as Customer"
    type: number
    sql: DATEDIFF(day,${created_date},CURRENT_DATE()) ;;
  }

  dimension: MonthCheck {
    label: "Months as Customer"
    type: number
    sql: DATEDIFF(month,${created_date},CURRENT_DATE()) ;;
  }

  measure: average_days_from_signup {
    label: "Average Number of Days Since Sign Up"
    type: average
    sql: ${DayCheck} ;;
  }
  measure: average_months_from_signup {
    label: "Average Number of Months Since Sign Up"
    type: average
    sql: ${MonthCheck} ;;
  }

  dimension: day_tiers {
    label: "Sign Up Tiers by Day Cohort"
    type: tier
    tiers: [365,730,1095,1460]
    style: integer
    sql: ${DayCheck} ;;
  }

  dimension: month_tiers {
    label: "Sign Up Tiers by Month Cohort"
    type: tier
    tiers: [1,6,12,24,36,48,60]
    style: integer
    sql: ${MonthCheck} ;;
  }

  dimension: new_customer {
    type: yesno
    label: "New Customer"
    sql: ${DayCheck}<=90;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

 dimension: full_name {
   type: string
   sql: ${first_name}||' '||${last_name} ;;
 }





  # dimension: full_name {
  #   type: string
  #   sql: ${first_name}||' '||${last_name} ;;
  # }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    map_layer_name: us_states
    sql: ${TABLE}."STATE" ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}
