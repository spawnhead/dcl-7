# payments — Questions / UNKNOWN

1. UNKNOWN: точный SQL тела `select-payments` (используется `DAOUtils.fillGrid(..., "select-payments", ...)`).
   - How to verify: открыть SQL map/ресурсы, где определён `select-payments`; сопоставить фильтры с параметрами `PaymentsForm`.
2. UNKNOWN: правила прав доступа по ролям на clone/edit/create для экрана платежей в полном объёме.
   - How to verify: разобрать `xml-permissions.xml` + runtime-проверки в action/service layer.
3. UNKNOWN: точные тексты/коды ошибок из backend при невалидных данных (кроме declarative validation.xml).
   - How to verify: воспроизвести POST в legacy с невалидными payload и снять HTTP/Struts ошибки через HAR/logs.
