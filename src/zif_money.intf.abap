INTERFACE zif_money PUBLIC.
  TYPES:
    money_amount TYPE p LENGTH 9 DECIMALS 4.
  METHODS:
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns the currency.
    "! @parameter result | <p class="shorttext synchronized" lang="en">Currency (as CUKY type)</p>
    get_currency RETURNING VALUE(result) TYPE waers,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns money amount.
    "! @parameter result | <p class="shorttext synchronized" lang="en">Money amount</p>
    get_amount RETURNING VALUE(result) TYPE money_amount,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns money amount as the internal, SAP DB value.
    "! @parameter result | <p class="shorttext synchronized" lang="en">Money amount (DB value)</p>
    get_database_amount RETURNING VALUE(result) TYPE money_amount,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns new Money instance with amount converted to the specified currency.
    "! @parameter target_currency | <p class="shorttext synchronized" lang="en">Currency</p>
    "! @parameter exchange_date | <p class="shorttext synchronized" lang="en">Exchange rate date</p>
    "! @parameter exchange_type | <p class="shorttext synchronized" lang="en">Exchange type (M, P, etc. from TCURR)</p>
    "! @parameter result | <p class="shorttext synchronized" lang="en">New ZCL_MONEY instance with converted amount</p>
    convert_to_money IMPORTING target_currency TYPE waers
                               exchange_date   TYPE d DEFAULT sy-datum
                               exchange_type   TYPE string DEFAULT 'M'
                     RETURNING VALUE(result)   TYPE REF TO zif_money,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns the amount converted to the given currency.
    "! @parameter target_currency | <p class="shorttext synchronized" lang="en">Currency</p>
    "! @parameter exchange_date | <p class="shorttext synchronized" lang="en">Exchange date</p>
    "! @parameter exchange_type | <p class="shorttext synchronized" lang="en">Exchange type (M, P, etc. from TCURR)</p>
    "! @parameter result | <p class="shorttext synchronized" lang="en">Converted amount as ZIF_MONEY-&gt;MONEY_AMOUNT type</p>
    convert_to_amount IMPORTING target_currency TYPE waers
                                exchange_date   TYPE d DEFAULT sy-datum
                                exchange_type   TYPE string DEFAULT 'M'
                      RETURNING VALUE(result)   TYPE money_amount,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns the amount (as SAP DB internal value) converted to the given currency.
    "! @parameter target_currency | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter exchange_date | <p class="shorttext synchronized" lang="en">Exchange date</p>
    "! @parameter exchange_type | <p class="shorttext synchronized" lang="en">Exchange type</p>
    "! @parameter result | <p class="shorttext synchronized" lang="en">Amount as ZIF_MONEY-&gt;MONEY_AMOUNT type, SAP DB internal</p>
    convert_to_database_amount IMPORTING target_currency TYPE waers
                                         exchange_date   TYPE d DEFAULT sy-datum
                                         exchange_type   TYPE string DEFAULT 'M'
                               RETURNING VALUE(result)   TYPE money_amount,


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns money string representation.
    "! @parameter result | <p class="shorttext synchronized" lang="en">Money amount as string</p>
    to_string RETURNING VALUE(result) TYPE string.
ENDINTERFACE.
