from typing import Dict, Any

import mcp

from ..fibery_client import FiberyClient
from fibery_mcp_server.tools.schema import schema_tool_name, schema_tool, handle_schema
from fibery_mcp_server.tools.database import database_tool_name, database_tool, handle_database
from fibery_mcp_server.tools.query import query_tool_name, query_tool, handle_query
from fibery_mcp_server.tools.current_date import current_date_tool_name, current_date_tool, handle_current_date
from fibery_mcp_server.tools.create_entity import create_entity_tool_name, create_entity_tool, handle_create_entity


def handle_list_tools():
    return [schema_tool(), database_tool(), query_tool(), create_entity_tool(), current_date_tool()]


async def handle_tool_call(fibery_client: FiberyClient, name: str, arguments: Dict[str, Any]):
    if name == schema_tool_name:
        return await handle_schema(fibery_client)
    elif name == database_tool_name:
        return await handle_database(fibery_client, arguments)
    elif name == query_tool_name:
        return await handle_query(fibery_client, arguments)
    elif name == current_date_tool_name:
        return await handle_current_date()
    elif name == create_entity_tool_name:
        return await handle_create_entity(fibery_client, arguments)
    else:
        return [mcp.types.TextContent(type="text", text=f"Error: Unknown tool {name}")]


__all__ = [
    "handle_list_tools",
    "handle_tool_call",
]
