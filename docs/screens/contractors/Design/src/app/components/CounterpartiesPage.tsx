import React, { useState } from 'react';
import { 
  Layout, 
  Menu, 
  Button, 
  Input, 
  Select, 
  Table, 
  Checkbox, 
  Card, 
  Form, 
  Row, 
  Col, 
  Space, 
  Typography, 
  theme,
  ConfigProvider,
  Pagination
} from 'antd';
import { 
  SearchOutlined, 
  EditOutlined, 
  PlusOutlined, 
  FilterOutlined,
  ClearOutlined
} from '@ant-design/icons';
import type { ColumnsType } from 'antd/es/table';
import ruRU from 'antd/locale/ru_RU';

import { motion } from 'framer-motion';

const { Header, Content } = Layout;
const { Title } = Typography;
const { Option } = Select;

// --- Mock Data ---
interface DataType {
  key: string;
  name: string;
  fullName: string;
  address: string;
  phone: string;
  fax?: string;
  email: string;
  bankDetails: string;
  blocked: boolean;
}

const initialData: DataType[] = [
  {
    key: '1',
    name: 'ChromeDevTools T0054-final',
    fullName: 'ChromeDevTools T0054-final LLC',
    address: '220001 Минская Минск ул. Тесто...',
    phone: '+375171...',
    email: 'chrome@example.by',
    bankDetails: 'BY1111111111111111111111111111...',
    blocked: false,
  },
  {
    key: '2',
    name: 'Contragent Test 3',
    fullName: 'Contragent Test 3 Full',
    address: '',
    phone: '',
    email: '',
    bankDetails: '',
    blocked: false,
  },
  {
    key: '3',
    name: 'Smoke TASK21',
    fullName: 'Smoke TASK21 LLC',
    address: '220000 Минская Минск ул. Прим...',
    phone: '+375171...',
    fax: '+375171...',
    email: 'info@example.by',
    bankDetails: 'BY1234567890123456789012345...',
    blocked: false,
  },
  {
    key: '4',
    name: 'Test01',
    fullName: 'Contragent Test 1 Full',
    address: '220100 Минская Борисов ул. Ле...',
    phone: '+375171...',
    email: 'test01@example.by',
    bankDetails: 'BY9876543210987654321098765...',
    blocked: false,
  },
  {
    key: '5',
    name: 'ООО Рога и копыта',
    fullName: 'ООО Рога и копыта',
    address: '220000 Минская Минск ул. Прим...',
    phone: '+375171...',
    email: 'info@example.by',
    bankDetails: '',
    blocked: false,
  },
];

const CounterpartiesPage: React.FC = () => {
  const [form] = Form.useForm();
  const { token } = theme.useToken();
  const [dataSource, setDataSource] = useState<DataType[]>(initialData);

  // --- Columns Definition ---
  const columns: ColumnsType<DataType> = [
    {
      title: 'Наименование',
      dataIndex: 'name',
      key: 'name',
      width: 200,
    },
    {
      title: 'Полное наименование',
      dataIndex: 'fullName',
      key: 'fullName',
      width: 250,
    },
    {
      title: 'Адрес',
      dataIndex: 'address',
      key: 'address',
      width: 200,
      responsive: ['md'],
    },
    {
      title: 'Телефон',
      dataIndex: 'phone',
      key: 'phone',
      width: 120,
      responsive: ['lg'],
    },
    {
      title: 'Факс',
      dataIndex: 'fax',
      key: 'fax',
      width: 120,
      responsive: ['xl'],
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      width: 180,
      render: (text) => <a href={`mailto:${text}`}>{text}</a>,
      responsive: ['md'],
    },
    {
      title: 'Банковские реквизиты',
      dataIndex: 'bankDetails',
      key: 'bankDetails',
      width: 250,
      ellipsis: true,
      responsive: ['xl'],
    },
    {
      title: 'Блок',
      dataIndex: 'blocked',
      key: 'blocked',
      width: 60,
      render: (checked, record) => (
        <Checkbox 
          checked={checked} 
          onChange={(e) => {
            const newData = [...dataSource];
            const index = newData.findIndex(item => item.key === record.key);
            if (index > -1) {
              newData[index].blocked = e.target.checked;
              setDataSource(newData);
            }
          }} 
        />
      ),
    },
    {
      title: '',
      key: 'action',
      width: 50,
      render: () => <Button type="text" icon={<EditOutlined />} />,
    },
  ];

  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }} 
      animate={{ opacity: 1, y: 0 }} 
      transition={{ duration: 0.5 }}
      style={{ padding: '24px', minHeight: 'calc(100vh - 64px)' }}
    >
      <div style={{ marginBottom: 24 }}>
        <Title level={2} style={{ margin: 0 }}>Контрагенты</Title>
      </div>

      {/* --- Filter Section --- */}
      <Card bordered={false} style={{ marginBottom: 24, borderRadius: 8 }}>
        <Form
          form={form}
          layout="vertical"
          name="filter_form"
        >
          <Row gutter={[16, 16]}>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="name" style={{ margin: 0 }}>
                <Input placeholder="Наименование" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="fullName" style={{ margin: 0 }}>
                <Input placeholder="Полное наименование" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="account" style={{ margin: 0 }}>
                <Input placeholder="Расчётный счёт" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="address" style={{ margin: 0 }}>
                <Input placeholder="Адрес" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="email" style={{ margin: 0 }}>
                <Input placeholder="Email" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="unp" style={{ margin: 0 }}>
                <Input placeholder="УНП" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="user" style={{ margin: 0 }}>
                <Select placeholder="Пользователь" allowClear>
                  <Option value="user1">User 1</Option>
                  <Option value="user2">User 2</Option>
                </Select>
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6} xl={4}>
              <Form.Item name="department" style={{ margin: 0 }}>
                <Select placeholder="Отдел" allowClear>
                  <Option value="dept1">Отдел 1</Option>
                  <Option value="dept2">Отдел 2</Option>
                </Select>
              </Form.Item>
            </Col>
            <Col xs={24} lg={8} xl={8} style={{ display: 'flex', gap: 8, alignItems: 'flex-start' }}>
               <Button type="primary" icon={<FilterOutlined />}>
                 Применить фильтр
               </Button>
               <Button icon={<ClearOutlined />} onClick={() => form.resetFields()}>
                 Очистить фильтр
               </Button>
            </Col>
          </Row>
        </Form>
      </Card>

      {/* --- Table Section --- */}
      <Card bordered={false} bodyStyle={{ padding: 0 }} style={{ borderRadius: 8, overflow: 'hidden' }}>
        <div style={{ overflowX: 'auto' }}>
            <Table
              columns={columns}
              dataSource={dataSource}
              pagination={{
                position: ['bottomLeft'],
                showSizeChanger: true,
                defaultPageSize: 15,
                pageSizeOptions: ['10', '15', '20', '50'],
                showTotal: (total, range) => `${range[0]}-${range[1]} из ${total}`,
                locale: { items_per_page: '/ стр.' }
              }}
              rowClassName={(record, index) => index % 2 === 0 ? 'table-row-light' : 'table-row-dark'}
              size="middle"
              scroll={{ x: 1200 }} 
            />
        </div>
      </Card>

      <div style={{ marginTop: 24 }}>
        <Button type="primary" icon={<PlusOutlined />} size="large">
          Создать
        </Button>
      </div>
    </motion.div>
  );
};

export default CounterpartiesPage;
