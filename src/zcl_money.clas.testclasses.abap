CLASS lcl_unit_test DEFINITION DEFERRED.
CLASS zcl_money DEFINITION LOCAL FRIENDS lcl_unit_test.

"Assumes TCURX are default
CLASS lcl_unit_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      sets_amounts FOR TESTING,
      returns_string FOR TESTING,
      returns_amount FOR TESTING,
      returns_database_amount FOR TESTING,
      returns_currency FOR TESTING.
ENDCLASS.

"Integration tests - results depends on TCURR exchange rates.
CLASS lcl_int_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      converts_to_money FOR TESTING,
      converts_to_amount FOR TESTING,
      converts_to_database_amount FOR TESTING.
ENDCLASS.

CLASS lcl_unit_test IMPLEMENTATION.
  METHOD returns_amount.
    cl_abap_unit_assert=>assert_equals( exp = '1200.38' act = NEW zcl_money( amount = '1200.38' currency = 'USD' )->get_amount( ) ).
  ENDMETHOD.

  METHOD returns_database_amount.
    cl_abap_unit_assert=>assert_equals( exp = '1.0550' act = NEW zcl_money( amount = '10550' currency = 'JPY' )->get_database_amount( ) ).
  ENDMETHOD.

  METHOD returns_string.
    SET COUNTRY 'PL'.
    cl_abap_unit_assert=>assert_equals( exp = '100,50 EUR' act = NEW zcl_money( amount = '100.50' currency = 'EUR' )->to_string( ) ).
  ENDMETHOD.

  METHOD sets_amounts.
    DATA(money) = NEW zcl_money( amount = '1200.38' currency = 'USD' ).
    cl_abap_unit_assert=>assert_equals( exp = '1200.38' act = money->amount ).
    cl_abap_unit_assert=>assert_equals( exp = '12.0038' act = money->database_amount ).
    cl_abap_unit_assert=>assert_equals( exp = 'USD' act = money->currency ).

    DATA(money_jpy) = NEW zcl_money( amount = '10550' currency = 'JPY' ).
    cl_abap_unit_assert=>assert_equals( exp = '10550' act = money_jpy->amount ).
    cl_abap_unit_assert=>assert_equals( exp = '1.0550' act = money_jpy->database_amount ).
    cl_abap_unit_assert=>assert_equals( exp = 'JPY' act = money_jpy->currency ).
  ENDMETHOD.

  METHOD returns_currency.
    cl_abap_unit_assert=>assert_equals( exp = 'JPY' act = NEW zcl_money( amount = '10550' currency = 'JPY' )->get_currency( ) ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_int_test IMPLEMENTATION.
  METHOD converts_to_amount.
    DATA(money) = NEW zcl_money( amount = '100' currency = 'EUR' ).
    cl_abap_unit_assert=>assert_equals( exp = '94' act = money->convert_to_amount( target_currency = 'USD' ) ).
  ENDMETHOD.

  METHOD converts_to_database_amount.
    DATA(money) = NEW zcl_money( amount = '100' currency = 'EUR' ).
    cl_abap_unit_assert=>assert_equals( exp = '0.9400' act = money->convert_to_database_amount( target_currency = 'USD' ) ).
  ENDMETHOD.

  METHOD converts_to_money.
    DATA(money) = NEW zcl_money( amount = '100' currency = 'USD' ).
    DATA(converted_money) = money->convert_to_money( target_currency = 'EUR' ).
    cl_abap_unit_assert=>assert_equals( exp = '106.3800' act = converted_money->get_amount( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'EUR' act = converted_money->get_currency( ) ).

    money = NEW zcl_money( amount = '100' currency = 'EUR' ).
    converted_money = money->convert_to_money( target_currency = 'USD' ).
    cl_abap_unit_assert=>assert_equals( exp = '94' act = converted_money->get_amount( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'USD' act = converted_money->get_currency( ) ).

    money = NEW zcl_money( amount = '100' currency = 'CHF' ).
    converted_money = money->convert_to_money( target_currency = 'DKK' ).
    cl_abap_unit_assert=>assert_equals( exp = '490.5000' act = converted_money->get_amount( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'DKK' act = converted_money->get_currency( ) ).

    money = NEW zcl_money( amount = '490.50' currency = 'DKK' ).
    converted_money = money->convert_to_money( target_currency = 'CHF' ).
    cl_abap_unit_assert=>assert_equals( exp = '99.96' act = converted_money->get_amount( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'CHF' act = converted_money->get_currency( ) ).
  ENDMETHOD.
ENDCLASS.
