import { createRoot } from 'react-dom/client'

import { AppRouter } from './routes/router'
import './styles/index.css'

const root = document.getElementById('root')
if (!root) {
  throw new Error('Root element not found')
}

createRoot(root).render(<AppRouter />)
