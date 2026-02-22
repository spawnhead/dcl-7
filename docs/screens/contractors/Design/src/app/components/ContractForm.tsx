import React, { useState } from 'react';
import {
  Form,
  Input,
  Select,
  DatePicker,
  Checkbox,
  Button,
  Card,
  Row,
  Col,
  Space,
  Typography,
  Flex,
} from 'antd';
import {
  SaveOutlined,
  CloseOutlined,
  PlusOutlined,
} from '@ant-design/icons';
import { SpecificationsTable } from './SpecificationsTable';
import { FileUploadSection } from './FileUploadSection';
import locale from 'antd/es/date-picker/locale/ru_RU';

const { Title, Text } = Typography;
const { TextArea } = Input;

export function ContractForm() {
  const [form] = Form.useForm();
  const [isCanceled, setIsCanceled] = useState(false);

  const onFinish = (values: any) => {
    console.log('Form values:', values);
  };

  return (
    <Form
      form={form}
      layout="vertical"
      onFinish={onFinish}
      requiredMark="optional"
      size="large"
    >
      <Row gutter={24}>
        {/* Main Content - Left Column (2/3) */}
        <Col xs={24} lg={16}>
          <Flex vertical gap="large" style={{ width: '100%' }}>
            {/* Основные данные */}
            <Card>
              <Title level={4} style={{ marginTop: 0 }}>
                Основные данные
              </Title>
              <Text type="secondary" style={{ display: 'block', marginBottom: 24 }}>
                Основная информация о договоре
              </Text>

              <Row gutter={16}>
                <Col xs={24} md={12}>
                  <Form.Item
                    label="Номер"
                    name="number"
                    rules={[{ required: true, message: 'Введите номер договора' }]}
                    tooltip="Уникальный номер договора"
                  >
                    <Input placeholder="Введите номер договора" />
                  </Form.Item>
                </Col>

                <Col xs={24} md={12}>
                  <Form.Item
                    label="Дата"
                    name="date"
                    rules={[{ required: true, message: 'Выберите дату' }]}
                  >
                    <DatePicker
                      style={{ width: '100%' }}
                      format="DD.MM.YYYY"
                      locale={locale}
                      placeholder="Выберите дату"
                    />
                  </Form.Item>
                </Col>

                <Col xs={24} md={12}>
                  <Form.Item label="Срок действия" name="expirationDate">
                    <DatePicker
                      style={{ width: '100%' }}
                      format="DD.MM.YYYY"
                      locale={locale}
                      placeholder="Выберите срок действия"
                    />
                  </Form.Item>
                </Col>

                <Col xs={24} md={12}>
                  <Form.Item name="isReusable" valuePropName="checked">
                    <Checkbox style={{ marginTop: 30 }}>Многоразовый</Checkbox>
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* Контрагент и условия */}
            <Card>
              <Title level={4} style={{ marginTop: 0 }}>
                Контрагент и условия
              </Title>
              <Text type="secondary" style={{ display: 'block', marginBottom: 24 }}>
                Информация о контрагенте и условиях договора
              </Text>

              <Form.Item
                label="Контрагент"
                name="counterparty"
                rules={[{ required: true, message: 'Выберите контрагента' }]}
              >
                <Space.Compact style={{ width: '100%' }}>
                  <Select
                    placeholder="Выберите контрагента"
                    style={{ width: '100%' }}
                    options={[
                      { value: 'counterparty1', label: 'ООО "Компания 1"' },
                      { value: 'counterparty2', label: 'ООО "Компания 2"' },
                      { value: 'counterparty3', label: 'ИП Иванов И.И.' },
                    ]}
                  />
                  <Button icon={<PlusOutlined />} />
                </Space.Compact>
              </Form.Item>

              <Row gutter={16}>
                <Col xs={24} md={12}>
                  <Form.Item
                    label="Валюта"
                    name="currency"
                    rules={[{ required: true, message: 'Выберите валюту' }]}
                  >
                    <Select
                      placeholder="Выберите валюту"
                      options={[
                        { value: 'rub', label: 'RUB - Российский рубль' },
                        { value: 'usd', label: 'USD - Доллар США' },
                        { value: 'eur', label: 'EUR - Евро' },
                      ]}
                    />
                  </Form.Item>
                </Col>

                <Col xs={24} md={12}>
                  <Form.Item label="Продавец" name="seller">
                    <Select
                      placeholder="Выберите продавца"
                      options={[
                        { value: 'seller1', label: 'Продавец 1' },
                        { value: 'seller2', label: 'Продавец 2' },
                        { value: 'seller3', label: 'Продавец 3' },
                      ]}
                    />
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* Спецификации */}
            <Card>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 24 }}>
                <div>
                  <Title level={4} style={{ marginTop: 0, marginBottom: 4 }}>
                    Спецификации
                  </Title>
                  <Text type="secondary">Список спецификаций договора</Text>
                </div>
                <Button type="primary" icon={<PlusOutlined />}>
                  Создать спецификацию
                </Button>
              </div>

              <SpecificationsTable />
            </Card>

            {/* Примечание */}
            <Card>
              <Title level={4} style={{ marginTop: 0 }}>
                Примечание
              </Title>
              <Text type="secondary" style={{ display: 'block', marginBottom: 24 }}>
                Дополнительная информация о договоре
              </Text>

              <Form.Item
                label="Примечание"
                name="note"
                extra="Максимум 500 символов"
              >
                <TextArea
                  rows={4}
                  placeholder="Введите примечание к договору..."
                  maxLength={500}
                  showCount
                />
              </Form.Item>
            </Card>

            {/* Приложенные файлы */}
            <Card>
              <Title level={4} style={{ marginTop: 0 }}>
                Приложенные файлы
              </Title>
              <Text type="secondary" style={{ display: 'block', marginBottom: 24 }}>
                Документы, связанные с договором
              </Text>

              <FileUploadSection />
            </Card>
          </Flex>
        </Col>

        {/* Sidebar - Right Column (1/3) */}
        <Col xs={24} lg={8}>
          <Flex vertical gap="large" style={{ width: '100%' }}>
            {/* Статусы и документы */}
            <Card>
              <Title level={5} style={{ marginTop: 0 }}>
                Статусы и документы
              </Title>

              <Flex vertical gap="middle" style={{ width: '100%', marginTop: 24 }}>
                <Form.Item name="hasFaxCopy" valuePropName="checked" style={{ marginBottom: 0 }}>
                  <Checkbox>Факсовая копия</Checkbox>
                </Form.Item>

                <Form.Item name="hasOriginal" valuePropName="checked" style={{ marginBottom: 0 }}>
                  <Checkbox>Оригинал</Checkbox>
                </Form.Item>

                <Form.Item
                  name="isCanceled"
                  valuePropName="checked"
                  style={{ marginBottom: 0 }}
                >
                  <Checkbox onChange={(e) => setIsCanceled(e.target.checked)}>
                    Аннулирован
                  </Checkbox>
                </Form.Item>

                {isCanceled && (
                  <div style={{ paddingLeft: 24, marginTop: 16 }}>
                    <Form.Item
                      label="Дата аннулирования"
                      name="cancelDate"
                      rules={[{ required: true, message: 'Выберите дату аннулирования' }]}
                    >
                      <DatePicker
                        style={{ width: '100%' }}
                        format="DD.MM.YYYY"
                        locale={locale}
                        placeholder="Выберите дату"
                      />
                    </Form.Item>
                  </div>
                )}
              </Flex>
            </Card>

            {/* Actions */}
            <div className="sticky top-24">
              <Flex vertical gap="middle" style={{ width: '100%' }}>
                <Button
                  type="primary"
                  size="large"
                  block
                  icon={<SaveOutlined />}
                  htmlType="submit"
                >
                  Сохранить
                </Button>
                <Button
                  size="large"
                  block
                  icon={<CloseOutlined />}
                  onClick={() => form.resetFields()}
                >
                  Отмена
                </Button>
              </Flex>
            </div>
          </Flex>
        </Col>
      </Row>
    </Form>
  );
}