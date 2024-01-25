# API（简述）



## Data Structure

### 1. `Music`

```json
{
    "musicId": "string",
    "name": "string",
    "singer": "string",
    "duration": 0,
    "image": "string(URL/Time)", // 歌曲图片
    "file": "string(URL)", // 歌曲资源
    "isLike": true // 是否收藏
}
```

**注**：对于生成的音乐：`musicId`, `duration`, `file`,`isLike`都正常；`name`设置为"0"以标识其为生成的音乐,  `singer`存储提示词；`image`填生成时间，格式遵循ISO 8601格式，例如（`"2020-01-02 13:27:00"`）



## REST Requests

### 1. `getMusicListBySheet` (**Deprecated*)

**URL**: `{ip}getMusicListBySheet`

**Method**: `POST`

**Request Parameters**:

- `userId`: String
- `musicSheetId`: String

**Request Body**:
```json
{
  "userId": "user_id_here",
  "musicSheetId": "music_sheet_id_here"
}
```

**Response Type**: 

```json
{
    data: List<Music> // Json List
}
```



---

### 2. `getLike`（获取收藏歌单）

**URL**: `{ip}getLike`

**Method**: `POST`

**Request Parameters**:
- `userId`: String
- `currentPage`: Integer
- `pageSize`: Integer

**Request Body**:
```json
{
  "userId": "user_id_here",
  "currentPage": current_page_here,
  "pageSize": page_size_here
}
```

**Response Type**:

```json
{
    data: List<Music> // Json List
}
```

---

### 3. `getRecent`（获取最近播放）

**URL**: `{ip}getRecent`

**Method**: `POST`

**Request Parameters**:
- `userId`: String
- `currentPage`: Integer
- `pageSize`: Integer

**Request Body**:
```json
{
  "userId": "user_id_here",
  "currentPage": current_page_here,
  "pageSize": page_size_here
}
```

**Response Type**:

```json
{
    data: List<Music> // Json List
}
```

---

### 4. `likeMusic`（收藏音乐）

**URL**: `{ip}likeMusic`

**Method**: `POST`

**Request Parameters**:
- `userId`: String
- `musicId`: String

**Request Body**:
```json
{
  "userId": "user_id_here",
  "musicId": "music_id_here"
}
```

**Response Type**: `void` (Acknowledgment of action)

---

### 5. `dislikeMusic`（取消收藏）

**URL**: `{ip}dislikeMusic`

**Method**: `POST`

**Request Parameters**:
- `userId`: String
- `musicId`: String

**Request Body**:
```json
{
  "userId": "user_id_here",
  "musicId": "music_id_here"
}
```

**Response Type**: `void` (Acknowledgment of action)

---

### 6. `addRecent`（**Deprecated*）

**URL**: `{ip}addRecent`

**Method**: `POST`

**Request Parameters**:
- `userId`: String
- `musicId`: String

**Request Body**:
```json
{
  "userId": "user_id_here",
  "musicId": "music_id_here"
}
```

**Response Type**: `void` (Acknowledgment of action)

---

### 7. `getMusicDetail`（获取音乐详细信息）

**URL**: `{ip}getMusicDetail`

**Method**: `POST`

**Request Parameters**:
- `musicId`: String

**Request Body**:

```json
{
  "musicId": "music_id_here"
}
```

**Response Type**: `Music` (Detailed information of a single music track)

----

### 8. `getGeneratedMusic`（生成音乐）

**URL**: `{ip}getGeneratedMusic`

**Method**: `POST`

**Request Parameters**:

- `userId`: String
- `prompt`: String (提示词)

**Request Body**:

```json
{
  "musicId": "music_id_here",
  "prompt": "the_prompt_for_generating_music"
}
```

**Response Type**: `Music` (Detailed information of a single music track)

----

### 9. `getGeneratedHistory`（生成记录）

**URL**: `{ip}getGeneratedHistory`

**Method**: `POST`

**Request Parameters**:

- `userId`: String
- `currentPage`: Integer
- `pageSize`: Integer

**Request Body**:

```json
{
  "userId": "user_id_here",
  "currentPage": current_page_here,
  "pageSize": page_size_here
}
```

**Response Type**:

```json
{
    data: List<Music> // Json List
}
```

----

### 10. `getRecommended`（获取推荐音乐）

**URL**: `{ip}getRecommended`

**Method**: `POST`

**Request Parameters**:

- `userId`: String
- `currentPage`: Integer
- `pageSize`: Integer

**Request Body**:

```json
{
  "userId": "user_id_here",
  "currentPage": current_page_here,
  "pageSize": page_size_here
}
```

**Response Type**:

```json
{
    data: List<Music> // Json List
}
```

---

### 11. `fetchWebSocketUrl` （获取与AI聊天的URL）

**URL**: `{ip}fetchWebSocketUrl`

**Method**: `POST`

**Request Parameters**:

- `userId`: String

**Request Body**:

```json
{
  "userId": "user_id_here",
}
```

**Response Type**: 

```json
{
    data: "string(WebSocket URL)"
}
```

---

### 