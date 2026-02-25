import { Building2, Coins, LogOut, Menu, ShieldUser } from 'lucide-react'
import { Link, Outlet, useNavigate } from '@tanstack/react-router'

import { clearSession, loadSession } from '../auth/session'
import { useLayoutStore } from '../stores/layoutStore'

const navItems = [
  { to: '/references/countries', label: 'Страны', icon: Building2 },
  { to: '/references/currencies', label: 'Валюты', icon: Coins },
  { to: '/references/contractors', label: 'Контрагенты', icon: ShieldUser },
] as const

export function ReferencesLayout() {
  const session = loadSession()
  const navigate = useNavigate()
  const { sidebarOpen, toggleSidebar } = useLayoutStore()

  return (
    <div className='min-h-screen bg-slate-50 text-slate-900'>
      <div className='flex min-h-screen'>
        <aside className={`border-r border-slate-200 bg-white transition-all ${sidebarOpen ? 'w-64' : 'w-20'}`}>
          <div className='flex h-16 items-center justify-between border-b border-slate-200 px-4'>
            <span className={`text-sm font-semibold ${sidebarOpen ? 'opacity-100' : 'opacity-0'}`}>DCL Admin Shell</span>
            <button type='button' onClick={toggleSidebar} className='rounded border border-slate-200 p-2'>
              <Menu size={16} />
            </button>
          </div>

          <nav className='p-3'>
            <ul className='space-y-2'>
              {navItems.map((item) => {
                const Icon = item.icon
                return (
                  <li key={item.to}>
                    <Link
                      to={item.to}
                      className='flex items-center gap-3 rounded px-3 py-2 text-sm text-slate-700 hover:bg-slate-100'
                      activeProps={{ className: 'flex items-center gap-3 rounded bg-slate-900 px-3 py-2 text-sm text-white' }}
                    >
                      <Icon size={16} />
                      {sidebarOpen && <span>{item.label}</span>}
                    </Link>
                  </li>
                )
              })}
            </ul>
          </nav>
        </aside>

        <div className='flex flex-1 flex-col'>
          <header className='flex h-16 items-center justify-between border-b border-slate-200 bg-white px-6'>
            <h1 className='text-lg font-semibold'>Dashboard Shell</h1>
            <div className='flex items-center gap-3 text-sm'>
              <span className='rounded bg-slate-100 px-2 py-1'>
                {session?.username} ({session?.role})
              </span>
              <button
                type='button'
                onClick={async () => {
                  clearSession()
                  await navigate({ to: '/login' })
                }}
                className='inline-flex items-center gap-2 rounded border border-slate-200 px-3 py-1.5 text-sm hover:bg-slate-100'
              >
                <LogOut size={14} />
                Выйти
              </button>
            </div>
          </header>

          <main className='flex-1 p-6'>
            <div className='rounded-xl border border-slate-200 bg-white p-4 shadow-sm'>
              <Outlet />
            </div>
          </main>
        </div>
      </div>
    </div>
  )
}
