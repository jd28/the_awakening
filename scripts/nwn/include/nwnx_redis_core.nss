// Returns 1 if the last command produced an error.
int redisErr();

// Returns the last error message.
string redisErrStr();

// Pushes a argument to be used with redisCommand.
// We're pushing them separately because that's the only way
// to ensure binary-safe operation (since nwscript doesn't allow
// escaping special characters in strings).
void redisPushBinarySafe(string value);

// Execute a command with all arguments pushed before:
//   redisPushBinarySafe("SET");
//   redisPushBinarySafe("key");
//   redisPushBinarySafe("some value");
//   redisCommand();
// Is functionally equivalent to calling
//   SET key 'some value'
// in redis-cli.
//
// Returns the value given back by redis, or '' on nil and error.
//
// This way of calling stuff is, as the name implies, binary-safe.
// redisCommandRaw() is NOT.
string redisCommand();

// Execute a command as-is without doing any escaping or result parsing.
//
// This is slightly faster than redisCommand() but you need to pay
// extra attention to not feed it user-generated input that may contain
// control codes, quotes, or similar.
//
// This has not been passed through parseRedisReply() yet.
string redisCommandRaw(string command);

// If used after executing a command that returns an array (for example, SMEMBERS),
// this will return TRUE as long as there are more results in the given array.
// Will always be FALSE for commands not returning arrays.
//
// Example use:
// LRANGE("mykey", "5", "10");
// while (redisArrayFetch()) {
//     string elem = redisArrayGet();
//     // ...
// }
int redisArrayFetch();

// See redisArrayFetch().
string redisArrayGet();

// Make redis subscribe to the given channel (pattern).
// Use this instead of SUBSCRIBE because SUBSCRIBE operates on
// your command context and will break things unless you know what you are doing.
void redisSubscribe(string channel, int wildcard = 0);

// Make redis unsubscribe from the given channel (pattern).
// Use this instead of UNSUBSCRIBE because UNSUBSCRIBE operates on
// your command context and will break things unless you know what you are doing.
void redisUnsubscribe(string channel, int wildcard = 0);

// Returns the channel on which a message was received.
// Only valid inside the redis pubsub event script.
string redisGetEventChannel();
// Returns the message received.
// Only valid inside the redis pubsub event script.
string redisGetEventMessage();

// Store the given object as raw gff data.
// Examples for query: "SET someCreature %b"
// You need to make sure exactly one %b appears in it.
void redisSCO(string query, object obj);

// Examples for query: "GET someCreature"
object redisRCO(string query, location loc, object owner);

// This is a internally-used helper to parse the string format we got back from
// redis. This code takes about 10ms for 1000 calls and is a convenience tradeoff.
// You might want to use this yourself when calling redisCommandRaw();
string parseRedisReply(string ret);

const int
	REDIS_REPLY_STRING        = 1,
	REDIS_REPLY_ARRAY         = 2,
	REDIS_REPLY_INTEGER       = 3,
	REDIS_REPLY_NIL           = 4,
	REDIS_REPLY_STATUS        = 5,
	REDIS_REPLY_ERROR         = 6;

// Implementation below.

/* The following is all internal state.
 * Do not use this in your scripts, use the functions described above instead.
 */
int    __redisLastReplyType      = 0;   // The last REDIS_REPLY_
string __redisLastErrorStr       = "";  // The last error string if any.
string __redisLastReply          = "";  // The raw reply data, or the array contents with sizes.
string __redisLastReplyArray     = "";  // The last reply data for arrays (so that you can loop).
int    __redisLastReplyArraySize = 0;   // The last array size
int    __redisGetArrayOffset     = 0;   // The last-fetched offset into array results.
int    __redisGetArrayOffsetStr  = 0;   // The last-fetched string index into array result str.
string __redisArrayLastFetch     = "";  // The last-fetched result to return for arrayGet()

int redisErr() {
	return (__redisLastReplyType == REDIS_REPLY_ERROR);
}
string redisErrStr() {
	return __redisLastErrorStr;
}

string parseRedisReply(string ret) {
	string result = "";

	// Reply format: TYPE strlen(RESULT) result
	int pos_result_len = FindSubString(ret, " ", 0) + 1;
	int pos_result     = FindSubString(ret, " ", pos_result_len) + 1;

	int replytype  = StringToInt(GetSubString(ret, 0, pos_result_len));
	int result_len = StringToInt(GetSubString(ret, pos_result_len, pos_result));

	if (result_len == 0 && replytype == REDIS_REPLY_INTEGER)
		result_len = GetStringLength(ret) - pos_result;

	result = GetSubString(ret, pos_result, result_len);

	__redisLastReply          = result;
	__redisLastErrorStr       = "";
	__redisLastReplyType      = replytype;

	if (replytype == REDIS_REPLY_ARRAY) {
		int pos_array_contents = FindSubString(result, " ");
		string array_size = GetSubString(result, 0, pos_array_contents);

		__redisGetArrayOffset = 0;
		__redisGetArrayOffsetStr = 0;
		__redisLastReplyArraySize = StringToInt(array_size);
		__redisLastReplyArray = GetSubString(result, pos_array_contents + 1, result_len);

		result = array_size;
	}

	if (replytype == REDIS_REPLY_ERROR) {
		__redisLastErrorStr = result;
		result = "";
	}

	return result;
}

string redisCommand() {
	string redisStr = "NWNX!REDIS!CMD";
	SetLocalString(GetModule(), redisStr, "1");
	string ret = GetLocalString(GetModule(), redisStr);

	return parseRedisReply(ret);
}

string redisCommandRaw(string command) {
	string redisStr = "NWNX!REDIS!RAW";
	SetLocalString(GetModule(), redisStr, command);
	return GetLocalString(GetModule(), redisStr);
}


int redisArrayFetch() {
	int pos_end_of_sz = FindSubString(__redisLastReplyArray, " ", __redisGetArrayOffsetStr);
	int start_of_content = pos_end_of_sz + 1;
	string szstr = GetSubString(__redisLastReplyArray, __redisGetArrayOffsetStr,
		pos_end_of_sz - __redisGetArrayOffsetStr);
	int sz = StringToInt(szstr);
	int end_of_content = start_of_content + sz;

	__redisArrayLastFetch = GetSubString(__redisLastReplyArray, start_of_content, sz);
	__redisGetArrayOffsetStr = end_of_content + 1; // __redisGetArrayOffsetStr + " "

	__redisGetArrayOffset += 1;

	return __redisGetArrayOffset <= __redisLastReplyArraySize;
}

string redisArrayGet() {
	return 	__redisArrayLastFetch;
}


void redisSubscribe(string channel, int wildcard = 0) {
	if (wildcard)
		SetLocalString(GetModule(), "NWNX!REDIS!PSUBSCRIBE", channel);
	else
		SetLocalString(GetModule(), "NWNX!REDIS!SUBSCRIBE", channel);
}
void redisUnsubscribe(string channel, int wildcard = 0) {
	if (wildcard)
		SetLocalString(GetModule(), "NWNX!REDIS!PUNSUBSCRIBE", channel);
	else
		SetLocalString(GetModule(), "NWNX!REDIS!UNSUBSCRIBE", channel);
}

void redisPushBinarySafe(string value) {
	if (value == "")
		SetLocalString(GetModule(), "NWNX!REDIS!PUSHEMPTY", "1");
	else
		SetLocalString(GetModule(), "NWNX!REDIS!PUSH", value);
}

string redisGetEventChannel() {
	SetLocalString(GetModule(), "NWNX!REDIS!GETEVCHAN", "1");
	return GetLocalString(GetModule(), "NWNX!REDIS!GETEVCHAN");
}
string redisGetEventMessage() {
	SetLocalString(GetModule(), "NWNX!REDIS!GETEVMSG", "1");
	return GetLocalString(GetModule(), "NWNX!REDIS!GETEVMSG");
}

void redisSCO(string query, object obj) {
	SetLocalString(GetModule(), "NWNX!REDIS!SETSCORCOQUERY", query);
	StoreCampaignObject("NWNX", "REDIS", obj);
}

object redisRCO(string query, location loc, object owner) {
	SetLocalString(GetModule(), "NWNX!REDIS!SETSCORCOQUERY", query);
	return RetrieveCampaignObject("NWNX", "REDIS", loc, owner, OBJECT_INVALID);
}
