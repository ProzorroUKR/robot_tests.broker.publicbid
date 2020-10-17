*** Settings ***

Resource                                                        publicbid_common.robot
Resource                                                        publicbid_question_variables.robot

*** Keywords ***

add question
    [Arguments]                                                 ${username}  ${tender_uaid}  ${type}  ${type_id}  ${question}
    [Documentation]                                             Створити запитання з question в описі для тендера tender_uaid.

    click visible element                                       ${question_form_open_btn_locator}
    open popup by btn locator                                   ${question_form_open_create_btn_locator}
    Wait Until Page Contains                                    ${popup_opened_content_success_locator}  60
    wait until element is visible                               ${question_form_create_questionform_title_input_locator}  60
    wait until popup is visible
#    input text to exist visible input                           ${question_form_open_form_answer_input_locator}  ${question.data.answer}
    Run Keyword If  '${type}' == 'tender'                       Select From List By Label  ${question_form_create_questionform_related_of_input_locator}  Закупівля
    Run Keyword If  '${type}' == 'lot'                          Select From List By Label  ${question_form_create_questionform_related_of_input_locator}  Лот
    Run Keyword If  '${type}' == 'lot'                          run keyword and ignore error  Click Element  ${question_form_create_questionform_related_lot_input_locator}
    ${question_form_create_questionform_related_lot_input_locator} =    Run Keyword If  '${type}' == 'lot'   replace string  ${question_form_create_questionform_related_lot_input_locator_tpl}  %type_id%  ${type_id}
    Run Keyword If  '${type}' == 'lot'                          run keyword and ignore error  Click Element  ${question_form_create_questionform_related_lot_input_locator}
    Run Keyword If  '${type}' == 'item'                         Select From List By Label  ${question_form_create_questionform_related_of_input_locator}  Предмет закупівлі
    Run Keyword If  '${type}' == 'item'                         run keyword and ignore error  Click Element  ${question_form_create_questionform_related_item_input_locator}
    ${question_form_create_questionform_related_item_input_locator} =    Run Keyword If  '${type}' == 'item'   replace string  ${question_form_create_questionform_related_item_input_locator_tpl}  %type_id%  ${type_id}
    Run Keyword If  '${type}' == 'item'                         run keyword and ignore error  Click Element   ${question_questionform_related_item_input_locator}
    input text to exist visible input                           ${question_form_create_questionform_title_input_locator}  ${question.data.title}
    input text to exist visible input                           ${question_form_create_questionform_description_input_locator}  ${question.data.description}
    submit form and check result                                ${question_form_answer_submit_btn_locator}  ${question_form_submit_success_msg}  ${tender_created_checker_element_locator}  ${true}
#    click visible element                                       ${question_form_answer_submit_btn_locator}
    wait until page does not contain element with reloading     ${tender_sync_element_locator}
    sleep  5

answer question
    [Arguments]                                                 ${answer_data}  ${question_id}
    [Documentation]                                             Дати відповідь answer_data на запитання з question_id в описі для тендера tender_uaid.

    click visible element                                       ${question_form_open_btn_locator}
    ${question_open_form_answer_locator} =                      replace string  ${question_open_form_answer_btn_locator_tpl}  %title%  ${question_id}
    wait until page contains element with reloading             ${question_open_form_answer_locator}
    ${question_form_open_form_answer_btn_locator} =             replace string  ${question_form_open_form_answer_btn_locator_tpl}  %title%  ${question_id}
    wait until page contains element with reloading             ${question_form_open_form_answer_btn_locator}
    open popup by btn locator                                   ${question_form_open_form_answer_btn_locator}
    input text to exist visible input                           ${question_answer_form_answer_input_locator}  ${answer_data.data.answer}
    submit form and check result                                ${question_answer_form_submit_btn_locator}  ${question_form_submit_answer_success_msg}  ${true}

get question information
    [Arguments]                                                 ${question_id}  ${field_name}
    [Documentation]                                             Отримати значення поля field_name із запитання з question_id
    ...                                                         в описі для тендера tender_uaid.

    submit form and check result                                ${bid_form_refresh_btn_locator}  ${bid_form_refresh_success_msg}  ${tender_created_checker_element_locator}  ${true}
    click visible element                                       ${question_form_open_btn_locator}
    ${question_open_form_answer_locator} =                      replace string  ${question_open_form_answer_btn_locator_tpl}  %title%  ${question_id}
    wait until page contains element with reloading             ${question_open_form_answer_locator}
    ${question_title_value_locator} =                           Run Keyword If  'title' == '${field_name}'   replace string  ${question_title_value_locator_tpl}  %title%  ${question_id}
    ${question_answer_value_locator} =                          Run Keyword If  'answer' == '${field_name}'  replace string  ${question_answer_value_locator_tpl}  %title%  ${question_id}
    ${question_description_value_locator} =                     Run Keyword If  'description' == '${field_name}'   replace string  ${question_description_value_locator_tpl}  %title%  ${question_id}
    Run Keyword If  'answer' == '${field_name}'                 wait until page contains element with reloading  ${question_answer_value_locator}
    ${return_value} =                                           Run Keyword If  'title' == '${field_name}'         get_text  ${question_title_value_locator}
    ...  ELSE                                                   Run Keyword If  'answer' == '${field_name}'        get_text  ${question_answer_value_locator}
    ...  ELSE                                                   Run Keyword If  'description' == '${field_name}'   get_text  ${question_description_value_locator}
    [Return]                                                    ${return_value}


