import { FormEvent, useEffect, useState } from 'react'
import { useNavigate } from '@tanstack/react-router'

import { loadSession } from '../auth/session'
import {
  blockContractor,
  deleteContractor,
  fetchContractorLookups,
  fetchContractors,
  type Contractor,
  type ContractorPermissions,
} from '../api/contractors'

export function ContractorsPanel() {
  const navigate = useNavigate()
  const session = loadSession()
  const role = session?.role ?? 'USER'
  const [permissions, setPermissions] = useState<ContractorPermissions>({
    canCreate: false,
    canEdit: false,
    canBlock: false,
    canDelete: false,
  })

  const [name, setName] = useState('')
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [unp, setUnp] = useState('')
  const [page, setPage] = useState(1)
  const [items, setItems] = useState<Contractor[]>([])
  const [hasNext, setHasNext] = useState(false)
  const [error, setError] = useState('')

  const load = async (nextPage = page) => {
    try {
      setError('')
      const result = await fetchContractors({
        ctrName: name,
        ctrFullName: fullName,
        ctrEmail: email,
        ctrUnp: unp,
        page: nextPage,
        pageSize: 15,
      })
      setPage(result.page)
      setItems(result.items)
      setHasNext(result.hasNextPage)
    } catch {
      setError('Не удалось загрузить контрагентов')
    }
  }

  useEffect(() => {
    const init = async () => {
      try {
        const lookups = await fetchContractorLookups(role)
        setPermissions(lookups.permissions)
      } catch {
        setError('Не удалось загрузить права на действия с контрагентами')
      }
      await load(1)
    }
    void init()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const onApply = async (event: FormEvent) => {
    event.preventDefault()
    await load(1)
  }

  const clear = async () => {
    setName('')
    setFullName('')
    setEmail('')
    setUnp('')
    await fetchContractors({ page: 1, pageSize: 15 }).then((res) => {
      setPage(res.page)
      setItems(res.items)
      setHasNext(res.hasNextPage)
    })
  }

  return (
    <section>
      <div className="mb-2 flex items-center justify-between">
        <h2 className="text-2xl font-semibold">Контрагенты</h2>
        <button
          type="button"
          onClick={() => void navigate({ to: '/references/contractors/new' })}
          disabled={!permissions.canCreate}
          className="rounded bg-slate-900 px-3 py-2 text-white disabled:opacity-50"
        >
          Создать
        </button>
      </div>
      <form onSubmit={onApply} className="mb-4 grid grid-cols-4 gap-2">
        <input
          className="rounded border px-3 py-2"
          placeholder="Наименование"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <input
          className="rounded border px-3 py-2"
          placeholder="Полное наименование"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
        />
        <input
          className="rounded border px-3 py-2"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          className="rounded border px-3 py-2"
          placeholder="УНП"
          value={unp}
          onChange={(e) => setUnp(e.target.value)}
        />
        <button type="submit" className="rounded bg-slate-900 px-3 py-2 text-white">
          Применить фильтр
        </button>
        <button type="button" onClick={clear} className="rounded border px-3 py-2">
          Очистить фильтр
        </button>
      </form>

      {error && <div className="mb-4 rounded bg-red-100 p-2 text-red-700">{error}</div>}

      <table className="w-full border-collapse border text-sm">
        <thead>
          <tr className="bg-slate-100">
            <th className="border p-2">Наименование</th>
            <th className="border p-2">Полное</th>
            <th className="border p-2">Email</th>
            <th className="border p-2">Телефон</th>
            <th className="border p-2">Блок</th>
            <th className="border p-2">Действия</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.ctrId}>
              <td className="border p-2">{item.ctrName}</td>
              <td className="border p-2">{item.ctrFullName}</td>
              <td className="border p-2">{item.ctrEmail}</td>
              <td className="border p-2">{item.ctrPhone}</td>
              <td className="border p-2 text-center">
                <input
                  type="checkbox"
                  checked={item.ctrBlock === '1'}
                  disabled={!permissions.canBlock}
                  onChange={async (e) => {
                    await blockContractor(Number(item.ctrId), e.target.checked ? 1 : 0, role)
                    await load(page)
                  }}
                />
              </td>
              <td className="border p-2">
                <div className="flex gap-2">
                  <button
                    type="button"
                    className="rounded border px-2 py-1 disabled:opacity-50"
                    disabled={!permissions.canEdit}
                    onClick={() => void navigate({ to: '/references/contractors/$ctrId/edit', params: { ctrId: item.ctrId } })}
                  >
                    Изменить
                  </button>
                  <button
                    type="button"
                    className="rounded border border-red-200 px-2 py-1 text-red-700 disabled:opacity-50"
                    disabled={!permissions.canDelete || item.occupied}
                    onClick={async () => {
                      const ok = window.confirm('Удалить контрагента?')
                      if (!ok) return
                      await deleteContractor(Number(item.ctrId), role)
                      await load(page)
                    }}
                  >
                    Удалить
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="mt-4 flex items-center gap-2">
        <button
          type="button"
          className="rounded border px-3 py-1"
          disabled={page <= 1}
          onClick={() => void load(page - 1)}
        >
          Prev
        </button>
        <span>Page {page}</span>
        <button
          type="button"
          className="rounded border px-3 py-1"
          disabled={!hasNext}
          onClick={() => void load(page + 1)}
        >
          Next
        </button>
      </div>
    </section>
  )
}
