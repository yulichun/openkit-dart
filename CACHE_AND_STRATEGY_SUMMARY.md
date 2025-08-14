# 缓存系统和发送策略完善总结

## 已实现的缓存系统

### 1. BeaconCache 接口和实现

#### CacheEntry 类
```dart
class CacheEntry {
  final String prefix;
  final CommunicationState communicationState;
  final Session session;
  final PayloadBuilder builder;
  bool initialized;
}
```

#### BeaconCache 接口
- `getEntriesCopy()` - 获取所有条目的副本
- `register()` - 注册新会话
- `getAllUninitializedSessions()` - 获取所有未初始化的会话
- `getAllClosedSessions()` - 获取所有已关闭的会话
- `getAllInitializedSessions()` - 获取所有已初始化的会话
- `unregister()` - 注销条目

#### BeaconCacheImpl 实现
- 使用 `List<CacheEntry>` 存储所有缓存条目
- 提供高效的查询和过滤功能
- 支持会话生命周期管理

### 2. 缓存条目管理

#### 会话状态跟踪
- **未初始化**: 新创建的会话，等待与服务器通信
- **已初始化**: 已与服务器建立通信的会话
- **已关闭**: 已结束的会话，等待数据发送完成

#### 通信状态管理
- 服务器ID管理
- 捕获模式控制
- 流量控制参数
- 时间戳管理

## 已增强的发送策略

### 1. 策略层次结构

```
SendingStrategy (接口)
├── AbstractSendingStrategy (抽象基类)
    ├── FlushLeftoversStrategy (关闭时刷新策略)
        ├── ImmediateSendingStrategy (立即发送策略)
        └── IntervalSendingStrategy (定时发送策略)
```

### 2. ImmediateSendingStrategy (立即发送策略)

#### 特点
- 适用于Web环境
- 对关键事件立即响应
- 支持自定义刷新事件类型

#### 触发条件
```dart
final _flushEventTypes = [
  EventType.crash,        // 崩溃事件
  EventType.error,        // 错误事件
  EventType.manualAction, // 手动操作
  EventType.identifyUser, // 用户识别
  EventType.sessionStart, // 会话开始
  EventType.sessionEnd,   // 会话结束
  EventType.webRequest,   // Web请求
];
```

#### 工作流程
1. 监听 `PayloadBuilder` 的 `added` 事件
2. 检查事件类型是否在刷新列表中
3. 如果是关键事件，立即触发 `flush()`

### 3. IntervalSendingStrategy (定时发送策略)

#### 特点
- 适用于服务器环境
- 定期批量发送数据
- 可配置发送间隔

#### 配置选项
```dart
static const int _defaultLoopTimeout = 1000; // 1秒间隔
```

#### 工作流程
1. 启动定时器，按配置间隔运行
2. 每次定时器触发时调用 `flush()`
3. 关闭时取消定时器并刷新剩余数据

### 4. FlushLeftoversStrategy (剩余数据刷新策略)

#### 特点
- 继承自 `AbstractSendingStrategy`
- 在策略关闭时刷新所有剩余数据
- 确保数据不丢失

#### 实现
```dart
@override
Future<void> shutdown() async {
  if (sender != null) {
    await sender!.flushImmediate();
  }
}
```

## 系统集成

### 1. BeaconSender 集成

#### 缓存管理
- 在初始化时更新所有缓存条目的通信状态
- 支持会话添加、删除和状态更新
- 集成发送策略的初始化和关闭

#### 数据发送流程
```
1. 发送新会话请求
   ├── 获取所有未初始化会话
   ├── 发送状态请求到服务器
   └── 更新会话状态

2. 发送负载数据
   ├── 获取所有已初始化会话
   ├── 检查捕获模式
   └── 发送或清理数据

3. 完成会话
   ├── 获取所有已关闭会话
   ├── 发送剩余数据
   └── 注销会话条目
```

### 2. 策略管理

#### 初始化流程
```dart
for (final strategy in _sendingStrategies) {
  strategy.init(this, _cache);
}
```

#### 会话添加处理
```dart
void sessionAdded(dynamic entry) {
  if (entry is CacheEntry) {
    entry.communicationState.setServerId(_okServerId);
    
    for (final strategy in _sendingStrategies) {
      strategy.entryAdded(entry);
    }
  }
}
```

#### 关闭流程
```dart
Future<void> shutdown() async {
  // 关闭所有会话
  for (final entry in _cache.getEntriesCopy()) {
    entry.session.end();
  }
  
  // 关闭发送策略
  for (final strategy in _sendingStrategies) {
    await strategy.shutdown();
  }
}
```

## 使用示例

### 1. 创建缓存和策略
```dart
final cache = BeaconCacheImpl();
final strategies = [
  ImmediateSendingStrategy(),
  IntervalSendingStrategy(2000), // 2秒间隔
];

final beaconSender = BeaconSenderImpl(
  openKit,
  cache,
  config,
);
```

### 2. 注册会话
```dart
final entry = cache.register(
  session,
  'session_prefix',
  payloadBuilder,
  communicationState,
);

beaconSender.sessionAdded(entry);
```

### 3. 策略自动管理
- **ImmediateSendingStrategy**: 自动监听关键事件并立即发送
- **IntervalSendingStrategy**: 自动按间隔发送数据
- **FlushLeftoversStrategy**: 自动在关闭时刷新剩余数据

## 技术特点

### 1. 类型安全
- 完整的Dart类型系统支持
- 编译时错误检查
- 清晰的接口定义

### 2. 异步处理
- 使用 `Future` 和 `async/await`
- 非阻塞操作
- 高效的并发处理

### 3. 可扩展性
- 策略模式设计
- 易于添加新的发送策略
- 插件式架构

### 4. 内存管理
- 自动清理已关闭会话
- 防止内存泄漏
- 高效的缓存管理

## 下一步开发建议

1. **性能优化**
   - 批量发送优化
   - 数据压缩
   - 连接池管理

2. **错误处理**
   - 重试机制
   - 降级策略
   - 错误恢复

3. **监控和指标**
   - 发送成功率统计
   - 延迟监控
   - 性能指标收集

4. **配置管理**
   - 动态配置更新
   - 环境特定配置
   - 配置验证

5. **测试覆盖**
   - 单元测试
   - 集成测试
   - 性能测试
