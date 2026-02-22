import { FormEvent, useEffect, useState } from 'react'

import {
  createCountry,
  deleteCountry,
  fetchCountries,
  type Country,
  updateCountry,
} from '../api/countries'

export function CountriesPanel() {
  const [items, setItems] = useState<Country[]>([])
  const [name, setName] = useState('')
  const [editingId, setEditingId] = useState<number | null>(null)
  const [error, setError] = useState('')

  const load = async () => {
    try {
      setError('')
      setItems(await fetchCountries())
    } catch {
      setError('Не удалось загрузить страны')
    }
  }

  useEffect(() => {
    void load()
  }, [])

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault()
    const normalized = name.trim()
    if (!normalized) return

    try {
      if (editingId === null) {
        await createCountry(normalized)
      } else {
        await updateCountry(editingId, normalized)
      }
      setName('')
      setEditingId(null)
      await load()
    } catch {
      setError('Ошибка сохранения страны')
    }
  }

  return (
    <section>
      <h2 className="mb-2 text-2xl font-semibold">Справочник стран</h2>
      <form onSubmit={onSubmit} className="mb-6 flex gap-2">
        <input value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded border border-slate-300 px-3 py-2" placeholder="Название страны" maxLength={50} />
        <button type="submit" className="rounded bg-slate-900 px-4 py-2 text-white">{editingId === null ? 'Добавить' : 'Сохранить'}</button>
      </form>
      {error && <div className="mb-4 rounded bg-red-100 p-3 text-red-700">{error}</div>}
      <table className="w-full border-collapse border border-slate-200 text-sm">
        <thead><tr className="bg-slate-100"><th className="border border-slate-200 p-2 text-left">ID</th><th className="border border-slate-200 p-2 text-left">Название</th><th className="border border-slate-200 p-2 text-left">Действия</th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td className="border border-slate-200 p-2">{item.id}</td><td className="border border-slate-200 p-2">{item.name}</td>
              <td className="border border-slate-200 p-2"><div className="flex gap-2"><button type="button" className="rounded border px-2 py-1" onClick={() => { setEditingId(item.id); setName(item.name) }}>Изменить</button><button type="button" className="rounded border border-red-200 px-2 py-1 text-red-700" onClick={async () => { await deleteCountry(item.id); await load() }}>Удалить</button></div></td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  )
}
