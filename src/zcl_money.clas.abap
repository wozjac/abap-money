*MIT License
*
*Copyright (c) 2019 Jacek Woźniczak
*
*Permission is hereby granted, free of charge, to any person obtaining a copy
*of this software and associated documentation files (the "Software"), to deal
*in the Software without restriction, including without limitation the rights
*to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*copies of the Software, and to permit persons to whom the Software is
*furnished to do so, subject to the following conditions:
*
*The above copyright notice and this permission notice shall be included in all
*copies or substantial portions of the Software.
*
*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*SOFTWARE.
CLASS zcl_money DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      zif_money.

    ALIASES:
      convert_to_money FOR zif_money~convert_to_money,
      convert_to_amount FOR zif_money~convert_to_amount,
      convert_to_database_amount FOR zif_money~convert_to_database_amount,
      get_amount FOR zif_money~get_amount,
      get_currency FOR zif_money~get_currency,
      get_database_amount FOR zif_money~get_database_amount,
      to_string FOR zif_money~to_string.

    METHODS:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Creates Money instance. Only one amount (real or DB internal) must be provided.
      "! @parameter amount | <p class="shorttext synchronized" lang="en">Money amount</p>
      "! @parameter database_amount | <p class="shorttext synchronized" lang="en">Money amount as SAP DB internal value</p>
      "! @parameter currency | <p class="shorttext synchronized" lang="en">Currency</p>
      constructor IMPORTING amount                  TYPE zif_money=>money_amount OPTIONAL
                            database_amount         TYPE zif_money=>money_amount OPTIONAL
                            database_value_decimals TYPE i DEFAULT 2
                            currency                TYPE waers.

  PRIVATE SECTION.
    DATA:
      amount                  TYPE zif_money=>money_amount,
      database_amount         TYPE zif_money=>money_amount,
      database_value_decimals TYPE i,
      currency                TYPE waers.
ENDCLASS.

CLASS zcl_money IMPLEMENTATION.
  METHOD constructor.
    DATA factor TYPE REF TO data.
    DATA(lo_type_description) = cl_abap_elemdescr=>get_n( database_value_decimals + 1 ).
    CREATE DATA factor TYPE HANDLE lo_type_description.
    FIELD-SYMBOLS <factor> TYPE any.
    ASSIGN factor->* TO <factor>.
    <factor>+0(1) = 1.

    IF database_amount IS NOT INITIAL AND amount IS NOT INITIAL.
      RAISE EXCEPTION TYPE lcx_money_error
        EXPORTING
          text = 'Please provide only one amount'.
    ENDIF.

    me->currency = currency.

    SELECT SINGLE currdec INTO @DATA(currency_decimals) FROM tcurx WHERE currkey = @me->currency.

    IF sy-subrc <> 0. "default 2 decimals
      SHIFT <factor> BY 2 PLACES RIGHT.
    ELSE.
      SHIFT <factor> BY currency_decimals PLACES RIGHT.
    ENDIF.

    IF amount IS NOT INITIAL.
      me->amount = amount.
      me->database_amount = amount / <factor>.
    ENDIF.

    IF database_amount IS NOT INITIAL.
      me->database_amount = database_amount.
      me->amount = me->database_amount * <factor>.
    ENDIF.
  ENDMETHOD.

  METHOD zif_money~convert_to_money.
    DATA converted_amount TYPE zif_money=>money_amount.

    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING
        date             = exchange_date
        type_of_rate     = exchange_type
        local_currency   = target_currency
        foreign_amount   = me->database_amount
        foreign_currency = me->currency
      IMPORTING
        local_amount     = converted_amount.

    result = NEW zcl_money( database_amount = converted_amount currency = target_currency ).
  ENDMETHOD.

  METHOD zif_money~convert_to_amount.
    result = CAST zcl_money( convert_to_money(
      exchange_date = exchange_date
      exchange_type = exchange_type
      target_currency = target_currency
    ) )->amount.
  ENDMETHOD.

  METHOD zif_money~get_amount.
    result = me->amount.
  ENDMETHOD.

  METHOD zif_money~get_database_amount.
    result = me->database_amount.
  ENDMETHOD.

  METHOD zif_money~convert_to_database_amount.
    result = CAST zcl_money( convert_to_money(
      exchange_date = exchange_date
      exchange_type = exchange_type
      target_currency = target_currency
    ) )->database_amount.
  ENDMETHOD.

  METHOD zif_money~get_currency.
    result = me->currency.
  ENDMETHOD.

  METHOD zif_money~to_string.
    DATA character_amount TYPE c LENGTH 30.
    WRITE me->database_amount CURRENCY me->currency TO character_amount.
    result = |{ character_amount } { me->currency }|.
    CONDENSE result.
  ENDMETHOD.
ENDCLASS.
