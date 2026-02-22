import { Link, Outlet, useNavigate } from '@tanstack/react-router'

import { clearSession, loadSession } from '../auth/session'

export function ReferencesLayout() {
  const session = loadSession()
  const navigate = useNavigate()

  return (
    <main className="mx-auto max-w-5xl p-8 font-sans">
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-3xl font-bold">DCL Modern — Фаза 0</h1>
        <div className="flex items-center gap-3 text-sm">
          <span>{session?.username} ({session?.role})</span>
          <button
            type="button"
            onClick={async () => {
              clearSession()
              await navigate({ to: '/login' })
            }}
            className="rounded border px-2 py-1"
          >
            Выйти
          </button>
        </div>
      </div>

      <div className="mb-6 flex gap-2">
        <Link to="/references/countries" className="rounded border px-3 py-2" activeProps={{ className: 'rounded bg-slate-900 px-3 py-2 text-white' }}>Страны</Link>
        <Link to="/references/currencies" className="rounded border px-3 py-2" activeProps={{ className: 'rounded bg-slate-900 px-3 py-2 text-white' }}>Валюты</Link>
        <Link to="/references/contractors" className="rounded border px-3 py-2" activeProps={{ className: 'rounded bg-slate-900 px-3 py-2 text-white' }}>Контрагенты</Link>
      </div>

      <Outlet />
    </main>
  )
}
