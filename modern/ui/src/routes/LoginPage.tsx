import { FormEvent, useState } from 'react'
import { useNavigate } from '@tanstack/react-router'

import { login } from '../api/auth'
import { saveSession } from '../auth/session'

export function LoginPage() {
  const [username, setUsername] = useState('admin')
  const [password, setPassword] = useState('admin')
  const [error, setError] = useState('')
  const navigate = useNavigate()

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault()
    try {
      const session = await login(username, password)
      saveSession(session)
      await navigate({ to: '/references/countries' })
    } catch {
      setError('Неверный логин/пароль')
    }
  }

  return (
    <main className="mx-auto mt-24 max-w-md rounded border p-6">
      <h1 className="mb-4 text-2xl font-bold">Вход в DCL Modern</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="w-full rounded border px-3 py-2" value={username} onChange={(e) => setUsername(e.target.value)} placeholder="Логин" />
        <input className="w-full rounded border px-3 py-2" type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Пароль" />
        <button type="submit" className="w-full rounded bg-slate-900 px-4 py-2 text-white">Войти</button>
      </form>
      {error && <div className="mt-3 rounded bg-red-100 p-2 text-red-700">{error}</div>}
      <p className="mt-4 text-xs text-slate-500">Demo credentials: admin/admin, user/user</p>
    </main>
  )
}
