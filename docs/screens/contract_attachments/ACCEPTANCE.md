# N3a3 Contract attachments — Acceptance criteria (1:1)

## Parity MUST (FAIL если не выполнено)
1. Экран открывается по клику «Прикрепить» на Contract form (при showAttach: admin, economist, lawyer).
2. Grid: колонки originalFileName (link), Delete.
3. Кнопка «Прикрепить» → upload (file picker или drag-drop).
4. Download: клик по link → скачивание файла.
5. Delete: удаление из списка.
6. «Назад» → возврат на Contract form.
7. При create (con_id=null): deferred attach; файлы привязываются при save Contract.

## Приёмочные сценарии

### 1) Open from Contract create
- Trigger: Contract form /contracts/new, клик «Прикрепить».
- Expected: attachments grid (пустой или deferred), кнопка Прикрепить.

### 2) Upload
- Trigger: Прикрепить → выбар файла → upload.
- Expected: 200, grid +1 row.

### 3) Download
- Trigger: клик по link.
- Expected: download file.

### 4) Delete
- Trigger: Delete.
- Expected: 204, row removed.

### 5) Back
- Trigger: Назад.
- Expected: return /contracts/new.
