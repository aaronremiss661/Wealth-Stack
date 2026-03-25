#!/bin/bash
# Multi-Client Manager for RIA practices
# Usage: client-manager.sh [add|list|switch|profile|delete] [CLIENT_ID] [OPTIONS]
# Data stored in: ~/.wealthstack/clients/<client-id>/

ACTION=${1:-list}
CLIENT_ID=${2:-}

python3 -c "
import json, sys, os, shutil
from datetime import datetime

action = '$ACTION'
client_id = '$CLIENT_ID'
base_dir = os.path.expanduser('~/.wealthstack/clients')
active_file = os.path.expanduser('~/.wealthstack/active-client.json')

os.makedirs(base_dir, exist_ok=True)

def get_active_client():
    try:
        with open(active_file) as f:
            return json.load(f)
    except:
        return {'client_id': None, 'name': 'No active client'}

def set_active_client(cid, name):
    with open(active_file, 'w') as f:
        json.dump({'client_id': cid, 'name': name, 'switched_at': datetime.now().isoformat()}, f, indent=2)

def get_client_profile(cid):
    profile_path = os.path.join(base_dir, cid, 'profile.json')
    try:
        with open(profile_path) as f:
            return json.load(f)
    except:
        return None

if action == 'list':
    clients = []
    active = get_active_client()
    if os.path.exists(base_dir):
        for d in sorted(os.listdir(base_dir)):
            client_dir = os.path.join(base_dir, d)
            if os.path.isdir(client_dir):
                profile = get_client_profile(d)
                clients.append({
                    'client_id': d,
                    'name': profile.get('name', 'Unknown') if profile else 'No profile',
                    'risk_profile': profile.get('risk_profile', 'Not set') if profile else 'N/A',
                    'active': d == active.get('client_id'),
                    'created_at': profile.get('created_at', 'Unknown') if profile else 'Unknown'
                })
    print(json.dumps({
        'clients': clients,
        'count': len(clients),
        'active_client': active
    }, indent=2))

elif action == 'add':
    if not client_id:
        print(json.dumps({'error': 'Usage: client-manager.sh add CLIENT_ID'}))
        sys.exit(1)

    client_dir = os.path.join(base_dir, client_id)
    if os.path.exists(client_dir):
        print(json.dumps({'error': f'Client {client_id} already exists'}))
        sys.exit(1)

    # Create client directory structure
    for subdir in ['', 'portfolios', 'reports', 'goals']:
        os.makedirs(os.path.join(client_dir, subdir), exist_ok=True)

    # Create default profile
    profile = {
        'client_id': client_id,
        'name': client_id.replace('-', ' ').title(),
        'created_at': datetime.now().isoformat(),
        'risk_profile': 'Not assessed',
        'investment_horizon': 'Not set',
        'annual_income': 0,
        'monthly_savings': 0,
        'existing_investments': 0,
        'residential_status': 'Resident',
        'age': 0,
        'dependents': 0,
        'goals': [],
        'notes': ''
    }

    with open(os.path.join(client_dir, 'profile.json'), 'w') as f:
        json.dump(profile, f, indent=2)

    # Auto-switch to new client
    set_active_client(client_id, profile['name'])

    print(json.dumps({
        'status': 'success',
        'message': f'Client {client_id} created and set as active',
        'client_id': client_id,
        'directory': client_dir,
        'next_steps': [
            'Update profile: client-manager.sh profile CLIENT_ID',
            'Import portfolio: import-portfolio.sh FILE',
            'Run risk assessment: /risk-assess',
            'Set goals: /goal-planner'
        ]
    }, indent=2))

elif action == 'switch':
    if not client_id:
        print(json.dumps({'error': 'Usage: client-manager.sh switch CLIENT_ID'}))
        sys.exit(1)

    client_dir = os.path.join(base_dir, client_id)
    if not os.path.exists(client_dir):
        print(json.dumps({'error': f'Client {client_id} not found'}))
        sys.exit(1)

    profile = get_client_profile(client_id)
    name = profile.get('name', client_id) if profile else client_id
    set_active_client(client_id, name)

    # Create symlinks for active client's data
    portfolios_link = os.path.expanduser('~/.wealthstack/portfolios')
    client_portfolios = os.path.join(client_dir, 'portfolios')

    # Update latest.json symlink to point to client's portfolio
    client_latest = os.path.join(client_portfolios, 'latest.json')
    global_latest = os.path.join(portfolios_link, 'latest.json')

    print(json.dumps({
        'status': 'success',
        'message': f'Switched to client: {name}',
        'client_id': client_id,
        'risk_profile': profile.get('risk_profile', 'Not set') if profile else 'N/A',
        'portfolio_dir': client_portfolios,
        'note': 'All subsequent commands will operate on this client context'
    }, indent=2))

elif action == 'profile':
    if not client_id:
        # Show active client profile
        active = get_active_client()
        client_id = active.get('client_id')
        if not client_id:
            print(json.dumps({'error': 'No active client. Use: client-manager.sh switch CLIENT_ID'}))
            sys.exit(1)

    profile = get_client_profile(client_id)
    if profile:
        # Also check for portfolio
        portfolio_path = os.path.join(base_dir, client_id, 'portfolios', 'latest.json')
        has_portfolio = os.path.exists(portfolio_path)

        goals_path = os.path.join(base_dir, client_id, 'goals', 'goals.json')
        has_goals = os.path.exists(goals_path)

        reports = []
        reports_dir = os.path.join(base_dir, client_id, 'reports')
        if os.path.exists(reports_dir):
            reports = sorted(os.listdir(reports_dir))

        profile['has_portfolio'] = has_portfolio
        profile['has_goals'] = has_goals
        profile['reports'] = reports
        print(json.dumps(profile, indent=2))
    else:
        print(json.dumps({'error': f'Client {client_id} not found'}))

elif action == 'delete':
    if not client_id:
        print(json.dumps({'error': 'Usage: client-manager.sh delete CLIENT_ID'}))
        sys.exit(1)

    client_dir = os.path.join(base_dir, client_id)
    if not os.path.exists(client_dir):
        print(json.dumps({'error': f'Client {client_id} not found'}))
        sys.exit(1)

    # Check if active client
    active = get_active_client()
    if active.get('client_id') == client_id:
        set_active_client(None, 'No active client')

    shutil.rmtree(client_dir)
    print(json.dumps({
        'status': 'success',
        'message': f'Client {client_id} deleted',
        'warning': 'All client data including portfolios and reports have been permanently deleted'
    }, indent=2))

else:
    print(json.dumps({
        'error': f'Unknown action: {action}',
        'usage': {
            'list': 'client-manager.sh list — List all clients',
            'add': 'client-manager.sh add CLIENT_ID — Create new client',
            'switch': 'client-manager.sh switch CLIENT_ID — Switch active client',
            'profile': 'client-manager.sh profile [CLIENT_ID] — Show client profile',
            'delete': 'client-manager.sh delete CLIENT_ID — Delete client and all data'
        }
    }, indent=2))
"
