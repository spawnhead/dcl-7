import React, { useState } from 'react';
import { ConfigProvider, Layout, Menu, Button, Space, Typography, theme } from 'antd';
import ruRU from 'antd/locale/ru_RU';
import dayjs from 'dayjs';
import 'dayjs/locale/ru';
import { SunOutlined, MoonOutlined } from '@ant-design/icons';
import CounterpartiesPage from './components/CounterpartiesPage';

dayjs.locale('ru');

const { Header, Content } = Layout;
const { Text } = Typography;

const App: React.FC = () => {
  const [isDarkMode, setIsDarkMode] = useState(false);

  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
  };

  const menuItems = [
    { key: 'directories', label: 'Справочники' },
    { key: 'reports', label: 'Отчеты' },
    { key: 'orders', label: 'Заказы' },
    { key: 'contracts', label: 'Договора' },
    { key: 'development', label: 'Development' },
  ];

  return (
    <ConfigProvider
      locale={ruRU}
      theme={{
        algorithm: isDarkMode ? theme.darkAlgorithm : theme.defaultAlgorithm,
        token: {
          colorPrimary: '#1677ff',
          borderRadius: 6,
        },
      }}
    >
      <Layout style={{ minHeight: '100vh' }}>
        <Header style={{ 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'space-between',
          padding: '0 24px',
          background: isDarkMode ? '#001529' : '#001529', // Always dark header based on screenshot
        }}>
           <div style={{ display: 'flex', alignItems: 'center' }}>
             {/* Logo placeholder or just menu */}
             <Menu
                theme="dark"
                mode="horizontal"
                defaultSelectedKeys={['directories']}
                items={menuItems}
                style={{ 
                  minWidth: 400, 
                  background: 'transparent',
                  borderBottom: 'none'
                }}
             />
           </div>
           
           <Space>
             <Space style={{ color: 'white', marginRight: 16 }}>
               <Text style={{ color: 'rgba(255,255,255,0.65)' }}>Светлая</Text>
               <Button 
                 type="text" 
                 icon={isDarkMode ? <MoonOutlined style={{ color: 'white' }} /> : <SunOutlined style={{ color: 'white' }} />} 
                 onClick={toggleTheme}
               />
               <Text style={{ color: 'rgba(255,255,255,0.65)' }}>Тёмная</Text>
             </Space>
           </Space>
        </Header>
        
        <Content style={{ 
          padding: 0, 
          background: isDarkMode ? '#141414' : '#f0f2f5' 
        }}>
          <CounterpartiesPage />
        </Content>
      </Layout>
    </ConfigProvider>
  );
};

export default App;
