import { FormEvent, useEffect, useState } from 'react'

import {
  createCurrency,
  deleteCurrency,
  fetchCurrencies,
  type Currency,
  updateCurrency,
} from '../api/currencies'

export function CurrenciesPanel() {
  const [items, setItems] = useState<Currency[]>([])
  const [name, setName] = useState('')
  const [noRound, setNoRound] = useState(0)
  const [sortOrder, setSortOrder] = useState(1)
  const [editingId, setEditingId] = useState<number | null>(null)
  const [error, setError] = useState('')

  const load = async () => {
    try {
      setError('')
      setItems(await fetchCurrencies())
    } catch {
      setError('Не удалось загрузить валюты')
    }
  }

  useEffect(() => {
    void load()
  }, [])

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault()
    const normalized = name.trim().toUpperCase()
    if (!normalized) return

    const payload = { name: normalized, noRound, sortOrder }
    try {
      if (editingId === null) {
        await createCurrency(payload)
      } else {
        await updateCurrency(editingId, payload)
      }
      setName('')
      setNoRound(0)
      setSortOrder(1)
      setEditingId(null)
      await load()
    } catch {
      setError('Ошибка сохранения валюты')
    }
  }

  return (
    <section>
      <h2 className="mb-2 text-2xl font-semibold">Справочник валют</h2>
      <form onSubmit={onSubmit} className="mb-6 grid grid-cols-4 gap-2">
        <input value={name} onChange={(e) => setName(e.target.value)} className="col-span-2 rounded border border-slate-300 px-3 py-2" placeholder="Код валюты (USD)" maxLength={10} />
        <input type="number" value={noRound} onChange={(e) => setNoRound(Number(e.target.value))} className="rounded border border-slate-300 px-3 py-2" placeholder="No round" />
        <input type="number" value={sortOrder} onChange={(e) => setSortOrder(Number(e.target.value))} className="rounded border border-slate-300 px-3 py-2" placeholder="Sort" />
        <button type="submit" className="col-span-4 rounded bg-slate-900 px-4 py-2 text-white">{editingId === null ? 'Добавить валюту' : 'Сохранить валюту'}</button>
      </form>
      {error && <div className="mb-4 rounded bg-red-100 p-3 text-red-700">{error}</div>}
      <table className="w-full border-collapse border border-slate-200 text-sm">
        <thead><tr className="bg-slate-100"><th className="border p-2 text-left">ID</th><th className="border p-2 text-left">Код</th><th className="border p-2 text-left">No round</th><th className="border p-2 text-left">Sort</th><th className="border p-2 text-left">Действия</th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td className="border p-2">{item.id}</td><td className="border p-2">{item.name}</td><td className="border p-2">{item.noRound ?? ''}</td><td className="border p-2">{item.sortOrder ?? ''}</td>
              <td className="border p-2"><div className="flex gap-2"><button type="button" className="rounded border px-2 py-1" onClick={() => { setEditingId(item.id); setName(item.name); setNoRound(item.noRound ?? 0); setSortOrder(item.sortOrder ?? 1) }}>Изменить</button><button type="button" className="rounded border border-red-200 px-2 py-1 text-red-700" onClick={async () => { await deleteCurrency(item.id); await load() }}>Удалить</button></div></td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  )
}
