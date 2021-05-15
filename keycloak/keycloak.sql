--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO dba;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO dba;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO dba;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO dba;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO dba;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO dba;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO dba;

--
-- Name: client; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO dba;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO dba;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO dba;

--
-- Name: client_default_roles; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_default_roles (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_default_roles OWNER TO dba;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO dba;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO dba;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO dba;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO dba;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_client (
    client_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO dba;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO dba;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO dba;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO dba;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO dba;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO dba;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO dba;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO dba;

--
-- Name: component; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO dba;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO dba;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO dba;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO dba;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO dba;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO dba;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO dba;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO dba;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO dba;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO dba;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO dba;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO dba;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO dba;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO dba;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO dba;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO dba;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO dba;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO dba;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO dba;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO dba;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO dba;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO dba;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO dba;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO dba;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO dba;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO dba;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO dba;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO dba;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO dba;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO dba;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO dba;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.realm OWNER TO dba;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_attribute OWNER TO dba;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO dba;

--
-- Name: realm_default_roles; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_default_roles (
    realm_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_roles OWNER TO dba;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO dba;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO dba;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO dba;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO dba;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO dba;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO dba;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO dba;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO dba;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO dba;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO dba;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO dba;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO dba;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO dba;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO dba;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO dba;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO dba;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO dba;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO dba;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO dba;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO dba;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO dba;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO dba;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO dba;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO dba;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO dba;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO dba;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO dba;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO dba;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO dba;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO dba;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO dba;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO dba;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO dba;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO dba;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO dba;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO dba;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
8c90fdc7-1c6b-4548-bd17-39b1a80d27a0	\N	auth-cookie	master	0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	2	10	f	\N	\N
1cc67939-7259-437d-a152-fa117c15d516	\N	auth-spnego	master	0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	3	20	f	\N	\N
c698166d-1e2a-40a0-8925-8f24d6b780b7	\N	identity-provider-redirector	master	0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	2	25	f	\N	\N
f67ae151-e432-4b56-8d01-57a3995245db	\N	\N	master	0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	2	30	t	8e50c3b0-d27e-44c1-9c82-1b56813d9d5d	\N
690ad0ef-1409-4862-96fa-e88ea672dd24	\N	auth-username-password-form	master	8e50c3b0-d27e-44c1-9c82-1b56813d9d5d	0	10	f	\N	\N
41f35e77-6a64-465f-a88c-cb24ec256d85	\N	\N	master	8e50c3b0-d27e-44c1-9c82-1b56813d9d5d	1	20	t	f9615384-1ea3-4cbc-8834-bb0de8d6913e	\N
03d5d882-b845-45ea-91f9-2c92049e49df	\N	conditional-user-configured	master	f9615384-1ea3-4cbc-8834-bb0de8d6913e	0	10	f	\N	\N
a86b6124-115c-4ef1-b17e-dbdbc7779b4a	\N	auth-otp-form	master	f9615384-1ea3-4cbc-8834-bb0de8d6913e	0	20	f	\N	\N
ed5a2039-f3a5-4904-94a8-8e1fc335c2ae	\N	direct-grant-validate-username	master	d8fab0e5-ba30-4881-8db1-0fec00e65c78	0	10	f	\N	\N
a230d63b-92a7-46b0-a480-b568fad957f1	\N	direct-grant-validate-password	master	d8fab0e5-ba30-4881-8db1-0fec00e65c78	0	20	f	\N	\N
8fbff89d-2c81-4315-9f92-6644f8cc9941	\N	\N	master	d8fab0e5-ba30-4881-8db1-0fec00e65c78	1	30	t	0d379cb7-ed86-486d-b307-e7d9efda9494	\N
d67c3fb0-7f0b-4b73-a877-2201836c0993	\N	conditional-user-configured	master	0d379cb7-ed86-486d-b307-e7d9efda9494	0	10	f	\N	\N
7f78427d-7970-4b2f-8e8d-5363168bd5d0	\N	direct-grant-validate-otp	master	0d379cb7-ed86-486d-b307-e7d9efda9494	0	20	f	\N	\N
3ef7cce8-2362-41cf-85c8-fcb62815e968	\N	registration-page-form	master	1c49c324-ee1e-47f7-b062-b2f4b3955e98	0	10	t	fa7f15c2-2a34-4628-9cd2-ffb044e851ba	\N
4d029ea0-70ea-439d-939d-be9ab37ffdb5	\N	registration-user-creation	master	fa7f15c2-2a34-4628-9cd2-ffb044e851ba	0	20	f	\N	\N
15c239be-69fd-4de4-9068-a860ef95e99a	\N	registration-profile-action	master	fa7f15c2-2a34-4628-9cd2-ffb044e851ba	0	40	f	\N	\N
3bcffe72-d745-4248-b850-d9cd80caacaf	\N	registration-password-action	master	fa7f15c2-2a34-4628-9cd2-ffb044e851ba	0	50	f	\N	\N
90216b02-d885-49f7-b098-6a7dc3f4b4fd	\N	registration-recaptcha-action	master	fa7f15c2-2a34-4628-9cd2-ffb044e851ba	3	60	f	\N	\N
62138c8f-1589-4c08-8bb4-7b4ee960806a	\N	reset-credentials-choose-user	master	400f0e71-8f1e-4843-a621-312c9d3477c8	0	10	f	\N	\N
3f33a62f-2887-400f-bf96-8b798a386d6d	\N	reset-credential-email	master	400f0e71-8f1e-4843-a621-312c9d3477c8	0	20	f	\N	\N
ff78f12f-dd82-446e-b3cd-b62d6feed565	\N	reset-password	master	400f0e71-8f1e-4843-a621-312c9d3477c8	0	30	f	\N	\N
95475810-c4cd-4c4d-88bb-98f25458009f	\N	\N	master	400f0e71-8f1e-4843-a621-312c9d3477c8	1	40	t	0f21b82f-464c-453c-9c12-8ea23a61087a	\N
ae4e69c8-e64c-42bd-ba7b-1ae934eaa592	\N	conditional-user-configured	master	0f21b82f-464c-453c-9c12-8ea23a61087a	0	10	f	\N	\N
c7e977da-cef0-4b40-8726-03e1773a315b	\N	reset-otp	master	0f21b82f-464c-453c-9c12-8ea23a61087a	0	20	f	\N	\N
df4f5993-6aaf-408f-b410-a202a464bca4	\N	client-secret	master	7dc04757-7dcd-42f7-8b25-97df19bd497d	2	10	f	\N	\N
fdda2a99-d548-41ce-8c3e-99ad86f617d7	\N	client-jwt	master	7dc04757-7dcd-42f7-8b25-97df19bd497d	2	20	f	\N	\N
a67624f4-2b6f-4f36-a7df-e8bd813127a9	\N	client-secret-jwt	master	7dc04757-7dcd-42f7-8b25-97df19bd497d	2	30	f	\N	\N
c259878f-e0bd-4a26-bb12-8ac38225aac4	\N	client-x509	master	7dc04757-7dcd-42f7-8b25-97df19bd497d	2	40	f	\N	\N
0c329ed0-6812-4dd1-bb1d-02ec687e7d9b	\N	idp-review-profile	master	7342b73b-c5ca-4c01-a6d6-156f059c7d8c	0	10	f	\N	a5f4c720-812a-47b2-a24e-836d5573f284
a08da467-4d0c-4902-a20f-15a9d9b01d6b	\N	\N	master	7342b73b-c5ca-4c01-a6d6-156f059c7d8c	0	20	t	40d7f2d3-8e50-4011-9edc-38c4f787180b	\N
acd145b0-b6f9-4856-8d4c-9e634180e003	\N	idp-create-user-if-unique	master	40d7f2d3-8e50-4011-9edc-38c4f787180b	2	10	f	\N	02a764ea-48af-4432-9a9b-f496dd7f10be
960f6d0d-700c-4b96-bf04-b34ae5fb29ee	\N	\N	master	40d7f2d3-8e50-4011-9edc-38c4f787180b	2	20	t	281db547-67e2-461b-8282-8d4890d509e6	\N
39206790-7ae1-4bba-9984-b2121cc5d6e0	\N	idp-confirm-link	master	281db547-67e2-461b-8282-8d4890d509e6	0	10	f	\N	\N
96479aea-f58a-4dd8-87b6-d92356f6d8cd	\N	\N	master	281db547-67e2-461b-8282-8d4890d509e6	0	20	t	0d43bd95-f205-4fde-aa1a-d5cefaee2339	\N
cd08a552-0cd4-4147-ac0d-25cbdb91943f	\N	idp-email-verification	master	0d43bd95-f205-4fde-aa1a-d5cefaee2339	2	10	f	\N	\N
6878052d-fb9b-4e0d-b8ae-44a340510ea3	\N	\N	master	0d43bd95-f205-4fde-aa1a-d5cefaee2339	2	20	t	91bce5d0-1258-4787-8265-eaa93f70a1d8	\N
e9636648-421d-442e-8245-51f98d3efe1f	\N	idp-username-password-form	master	91bce5d0-1258-4787-8265-eaa93f70a1d8	0	10	f	\N	\N
474b7fd9-20d1-400e-bd49-36b61ed85395	\N	\N	master	91bce5d0-1258-4787-8265-eaa93f70a1d8	1	20	t	55f6a008-b7b6-4f47-97fb-cb9ed7ba2ab2	\N
9d19da14-8e18-4b72-9414-c7c801a48edf	\N	conditional-user-configured	master	55f6a008-b7b6-4f47-97fb-cb9ed7ba2ab2	0	10	f	\N	\N
003206e9-42d9-4e79-961a-2f7d79f38fa9	\N	auth-otp-form	master	55f6a008-b7b6-4f47-97fb-cb9ed7ba2ab2	0	20	f	\N	\N
9db0ee31-58c3-42e0-a60d-482dd23eda53	\N	http-basic-authenticator	master	fcabf205-f373-4601-9749-f0d961fb2089	0	10	f	\N	\N
5caef614-9a05-4a5f-8a0c-0b44a7a86a07	\N	docker-http-basic-authenticator	master	e612fbe0-36de-4b5c-b050-fdcb7504a5ee	0	10	f	\N	\N
441d494b-86f4-47c8-bf28-a655932e4f28	\N	no-cookie-redirect	master	f18fd97d-8e89-4b56-9caf-22e6b9a15449	0	10	f	\N	\N
a5ffc921-d0cf-4c3f-b4f1-a4bd79f7da82	\N	\N	master	f18fd97d-8e89-4b56-9caf-22e6b9a15449	0	20	t	d47ca662-c4fd-4898-831e-51ceec270c3b	\N
63b124cc-5af0-444b-964f-f62801c4978f	\N	basic-auth	master	d47ca662-c4fd-4898-831e-51ceec270c3b	0	10	f	\N	\N
8bd5312f-19a4-411d-8f89-88a35ff476d8	\N	basic-auth-otp	master	d47ca662-c4fd-4898-831e-51ceec270c3b	3	20	f	\N	\N
32c106d4-8b5c-4849-9cf7-9a9d899a71ae	\N	auth-spnego	master	d47ca662-c4fd-4898-831e-51ceec270c3b	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	browser	browser based authentication	master	basic-flow	t	t
8e50c3b0-d27e-44c1-9c82-1b56813d9d5d	forms	Username, password, otp and other auth forms.	master	basic-flow	f	t
f9615384-1ea3-4cbc-8834-bb0de8d6913e	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
d8fab0e5-ba30-4881-8db1-0fec00e65c78	direct grant	OpenID Connect Resource Owner Grant	master	basic-flow	t	t
0d379cb7-ed86-486d-b307-e7d9efda9494	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
1c49c324-ee1e-47f7-b062-b2f4b3955e98	registration	registration flow	master	basic-flow	t	t
fa7f15c2-2a34-4628-9cd2-ffb044e851ba	registration form	registration form	master	form-flow	f	t
400f0e71-8f1e-4843-a621-312c9d3477c8	reset credentials	Reset credentials for a user if they forgot their password or something	master	basic-flow	t	t
0f21b82f-464c-453c-9c12-8ea23a61087a	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	master	basic-flow	f	t
7dc04757-7dcd-42f7-8b25-97df19bd497d	clients	Base authentication for clients	master	client-flow	t	t
7342b73b-c5ca-4c01-a6d6-156f059c7d8c	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	master	basic-flow	t	t
40d7f2d3-8e50-4011-9edc-38c4f787180b	User creation or linking	Flow for the existing/non-existing user alternatives	master	basic-flow	f	t
281db547-67e2-461b-8282-8d4890d509e6	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	master	basic-flow	f	t
0d43bd95-f205-4fde-aa1a-d5cefaee2339	Account verification options	Method with which to verity the existing account	master	basic-flow	f	t
91bce5d0-1258-4787-8265-eaa93f70a1d8	Verify Existing Account by Re-authentication	Reauthentication of existing account	master	basic-flow	f	t
55f6a008-b7b6-4f47-97fb-cb9ed7ba2ab2	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
fcabf205-f373-4601-9749-f0d961fb2089	saml ecp	SAML ECP Profile Authentication Flow	master	basic-flow	t	t
e612fbe0-36de-4b5c-b050-fdcb7504a5ee	docker auth	Used by Docker clients to authenticate against the IDP	master	basic-flow	t	t
f18fd97d-8e89-4b56-9caf-22e6b9a15449	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	master	basic-flow	t	t
d47ca662-c4fd-4898-831e-51ceec270c3b	Authentication Options	Authentication options.	master	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
a5f4c720-812a-47b2-a24e-836d5573f284	review profile config	master
02a764ea-48af-4432-9a9b-f496dd7f10be	create unique user config	master
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
02a764ea-48af-4432-9a9b-f496dd7f10be	false	require.password.update.after.registration
a5f4c720-812a-47b2-a24e-836d5573f284	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	t	master-realm	0	f	1e535741-48e7-45cd-b396-63ef92ecdb7b	\N	t	\N	f	master	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
06185161-1d64-445f-99af-b865b67b5324	t	f	account	0	f	0fbe01c0-753b-4756-a869-30e0d3eb432e	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
88d979f1-af0a-478d-a837-04a70e9fdef9	t	f	account-console	0	t	668ea67b-fc8c-4abe-9b38-77f8c5de0c0e	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
4d920f2c-4610-47fb-a5de-cb141bd936cc	t	f	broker	0	f	566ff58c-432a-4cd6-803d-e90f1b94183d	\N	f	\N	f	master	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
48b528c7-f14b-4582-b97e-56dd9ba87105	t	f	security-admin-console	0	t	1f059a99-08f3-405e-bac8-c25ef81f3894	/admin/master/console/	f	\N	f	master	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
7e37d71e-158b-4f76-98e6-679fcd809c22	t	f	admin-cli	0	t	0813279e-f2d3-4939-8a5f-47bd3b8951b1	\N	f	\N	f	master	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
88d979f1-af0a-478d-a837-04a70e9fdef9	S256	pkce.code.challenge.method
48b528c7-f14b-4582-b97e-56dd9ba87105	S256	pkce.code.challenge.method
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_default_roles; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_default_roles (client_id, role_id) FROM stdin;
06185161-1d64-445f-99af-b865b67b5324	996dcece-84da-499f-b608-5fa354980970
06185161-1d64-445f-99af-b865b67b5324	2e0d0160-b116-46e6-85c9-052f5b6f5e94
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
c6981dfc-1a4f-4353-8119-e3e070bc395d	offline_access	master	OpenID Connect built-in scope: offline_access	openid-connect
d6615c6a-c16e-445e-996e-bd4cf2de6f24	role_list	master	SAML role list	saml
51e68398-b458-4dbf-bfa0-ccdee7686819	profile	master	OpenID Connect built-in scope: profile	openid-connect
27a31baf-b429-4901-91ef-ad61320b82b6	email	master	OpenID Connect built-in scope: email	openid-connect
b5cc522e-37d2-4a87-bb2b-208bbf962cd9	address	master	OpenID Connect built-in scope: address	openid-connect
40c8a2e2-0da4-4375-bb5e-2465b859b356	phone	master	OpenID Connect built-in scope: phone	openid-connect
f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	roles	master	OpenID Connect scope for add user roles to the access token	openid-connect
d03ebe06-a975-4861-96b0-0c5f10e6332c	web-origins	master	OpenID Connect scope for add allowed web origins to the access token	openid-connect
e56ca7dc-1026-4f43-a944-ded83541ae1b	microprofile-jwt	master	Microprofile - JWT built-in scope	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
c6981dfc-1a4f-4353-8119-e3e070bc395d	true	display.on.consent.screen
c6981dfc-1a4f-4353-8119-e3e070bc395d	${offlineAccessScopeConsentText}	consent.screen.text
d6615c6a-c16e-445e-996e-bd4cf2de6f24	true	display.on.consent.screen
d6615c6a-c16e-445e-996e-bd4cf2de6f24	${samlRoleListScopeConsentText}	consent.screen.text
51e68398-b458-4dbf-bfa0-ccdee7686819	true	display.on.consent.screen
51e68398-b458-4dbf-bfa0-ccdee7686819	${profileScopeConsentText}	consent.screen.text
51e68398-b458-4dbf-bfa0-ccdee7686819	true	include.in.token.scope
27a31baf-b429-4901-91ef-ad61320b82b6	true	display.on.consent.screen
27a31baf-b429-4901-91ef-ad61320b82b6	${emailScopeConsentText}	consent.screen.text
27a31baf-b429-4901-91ef-ad61320b82b6	true	include.in.token.scope
b5cc522e-37d2-4a87-bb2b-208bbf962cd9	true	display.on.consent.screen
b5cc522e-37d2-4a87-bb2b-208bbf962cd9	${addressScopeConsentText}	consent.screen.text
b5cc522e-37d2-4a87-bb2b-208bbf962cd9	true	include.in.token.scope
40c8a2e2-0da4-4375-bb5e-2465b859b356	true	display.on.consent.screen
40c8a2e2-0da4-4375-bb5e-2465b859b356	${phoneScopeConsentText}	consent.screen.text
40c8a2e2-0da4-4375-bb5e-2465b859b356	true	include.in.token.scope
f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	true	display.on.consent.screen
f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	${rolesScopeConsentText}	consent.screen.text
f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	false	include.in.token.scope
d03ebe06-a975-4861-96b0-0c5f10e6332c	false	display.on.consent.screen
d03ebe06-a975-4861-96b0-0c5f10e6332c		consent.screen.text
d03ebe06-a975-4861-96b0-0c5f10e6332c	false	include.in.token.scope
e56ca7dc-1026-4f43-a944-ded83541ae1b	false	display.on.consent.screen
e56ca7dc-1026-4f43-a944-ded83541ae1b	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
06185161-1d64-445f-99af-b865b67b5324	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
88d979f1-af0a-478d-a837-04a70e9fdef9	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
7e37d71e-158b-4f76-98e6-679fcd809c22	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
4d920f2c-4610-47fb-a5de-cb141bd936cc	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
48b528c7-f14b-4582-b97e-56dd9ba87105	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
06185161-1d64-445f-99af-b865b67b5324	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
06185161-1d64-445f-99af-b865b67b5324	51e68398-b458-4dbf-bfa0-ccdee7686819	t
06185161-1d64-445f-99af-b865b67b5324	27a31baf-b429-4901-91ef-ad61320b82b6	t
06185161-1d64-445f-99af-b865b67b5324	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
06185161-1d64-445f-99af-b865b67b5324	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
06185161-1d64-445f-99af-b865b67b5324	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
06185161-1d64-445f-99af-b865b67b5324	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
06185161-1d64-445f-99af-b865b67b5324	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
88d979f1-af0a-478d-a837-04a70e9fdef9	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
88d979f1-af0a-478d-a837-04a70e9fdef9	51e68398-b458-4dbf-bfa0-ccdee7686819	t
88d979f1-af0a-478d-a837-04a70e9fdef9	27a31baf-b429-4901-91ef-ad61320b82b6	t
88d979f1-af0a-478d-a837-04a70e9fdef9	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
88d979f1-af0a-478d-a837-04a70e9fdef9	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
88d979f1-af0a-478d-a837-04a70e9fdef9	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
88d979f1-af0a-478d-a837-04a70e9fdef9	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
88d979f1-af0a-478d-a837-04a70e9fdef9	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
7e37d71e-158b-4f76-98e6-679fcd809c22	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
7e37d71e-158b-4f76-98e6-679fcd809c22	51e68398-b458-4dbf-bfa0-ccdee7686819	t
7e37d71e-158b-4f76-98e6-679fcd809c22	27a31baf-b429-4901-91ef-ad61320b82b6	t
7e37d71e-158b-4f76-98e6-679fcd809c22	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
7e37d71e-158b-4f76-98e6-679fcd809c22	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
7e37d71e-158b-4f76-98e6-679fcd809c22	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
7e37d71e-158b-4f76-98e6-679fcd809c22	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
7e37d71e-158b-4f76-98e6-679fcd809c22	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
4d920f2c-4610-47fb-a5de-cb141bd936cc	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
4d920f2c-4610-47fb-a5de-cb141bd936cc	51e68398-b458-4dbf-bfa0-ccdee7686819	t
4d920f2c-4610-47fb-a5de-cb141bd936cc	27a31baf-b429-4901-91ef-ad61320b82b6	t
4d920f2c-4610-47fb-a5de-cb141bd936cc	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
4d920f2c-4610-47fb-a5de-cb141bd936cc	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
4d920f2c-4610-47fb-a5de-cb141bd936cc	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
4d920f2c-4610-47fb-a5de-cb141bd936cc	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
4d920f2c-4610-47fb-a5de-cb141bd936cc	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	51e68398-b458-4dbf-bfa0-ccdee7686819	t
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	27a31baf-b429-4901-91ef-ad61320b82b6	t
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
48b528c7-f14b-4582-b97e-56dd9ba87105	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
48b528c7-f14b-4582-b97e-56dd9ba87105	51e68398-b458-4dbf-bfa0-ccdee7686819	t
48b528c7-f14b-4582-b97e-56dd9ba87105	27a31baf-b429-4901-91ef-ad61320b82b6	t
48b528c7-f14b-4582-b97e-56dd9ba87105	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
48b528c7-f14b-4582-b97e-56dd9ba87105	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
48b528c7-f14b-4582-b97e-56dd9ba87105	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
48b528c7-f14b-4582-b97e-56dd9ba87105	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
48b528c7-f14b-4582-b97e-56dd9ba87105	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
c6981dfc-1a4f-4353-8119-e3e070bc395d	1eb72a08-fd92-49ea-9834-ebd8f1c35283
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
7d18fce6-5072-494f-95a1-6448a18652f7	Trusted Hosts	master	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
113bf193-fa14-4888-806f-653dbe5cc122	Consent Required	master	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
785305ec-e83e-4051-be89-9076aac85b85	Full Scope Disabled	master	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
34ca994a-727f-4320-be3c-db82bf096bf2	Max Clients Limit	master	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
3b0fc113-b104-4460-b784-6e0a3b9db477	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
b210476e-d8ea-4d1a-a981-a8ef009cf535	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
bd71a432-c67c-482e-889c-43cdd02e0655	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
cb584f41-6a53-4a30-adf3-b76975d5f0ff	fallback-HS256	master	hmac-generated	org.keycloak.keys.KeyProvider	master	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
ea696eb1-ef86-491f-9b9d-e7c65628e837	7d18fce6-5072-494f-95a1-6448a18652f7	client-uris-must-match	true
ec4d5cf5-8adb-489c-914b-2283f9f6363b	7d18fce6-5072-494f-95a1-6448a18652f7	host-sending-registration-request-must-match	true
e19e9498-627d-4234-954a-e5bb8421adc4	bd71a432-c67c-482e-889c-43cdd02e0655	allow-default-scopes	true
94085c82-a2ae-451d-927e-cbbf37bd393d	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	oidc-full-name-mapper
2507a5f5-701d-4b67-a0b3-314167613e1f	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	saml-user-attribute-mapper
e6fd0d23-bbc4-450f-8109-6abc4df870d3	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	saml-role-list-mapper
d9b2bbd2-a81c-499e-a234-58b7b9f30872	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
59619b2b-af0b-4810-a095-c99db566e068	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	saml-user-property-mapper
28709140-3b9a-4e7c-b767-bfd65189c694	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c094c11f-c7a2-429c-b00f-4e3b1e0ccd8d	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
eb62fc52-df93-4ae6-b4e2-aa1cf1505709	3b0fc113-b104-4460-b784-6e0a3b9db477	allowed-protocol-mapper-types	oidc-address-mapper
e8c12152-0eb5-4245-8ecc-2ab1ed0fff4e	b210476e-d8ea-4d1a-a981-a8ef009cf535	allow-default-scopes	true
4bdb2326-cc00-4663-9271-ca6c5008d668	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
6be7ee44-ff1d-4593-9f87-f1c897a4b0bf	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	oidc-full-name-mapper
4dc624d6-52ea-4dbc-9357-631ba1e2e73b	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	saml-role-list-mapper
931fde85-2fa8-4be6-bbf1-10cbbcc4d386	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	oidc-address-mapper
b7db5223-1cbb-49c1-9a24-0ab83eb23fa0	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	saml-user-property-mapper
4cfa3eb9-687d-4e76-86e7-d9634b57835a	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
f063109e-ff2b-4e7a-bd04-32315d7f74ef	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
a49397ea-3949-4661-9af3-a1f43ff44d82	767c2448-5b11-43e4-ad9a-c0ff7d6d45d1	allowed-protocol-mapper-types	saml-user-attribute-mapper
f7578ee2-9353-4105-b09b-9d2e294ca131	34ca994a-727f-4320-be3c-db82bf096bf2	max-clients	200
9c9c9adf-011c-4076-ac71-b10a991b3bf3	cb584f41-6a53-4a30-adf3-b76975d5f0ff	kid	fa46f27d-2af2-46d0-a86f-0ca32a4184c9
1191e44a-6fdf-43b7-94c6-d5c9b75feac7	cb584f41-6a53-4a30-adf3-b76975d5f0ff	priority	-100
713b21b6-bb3b-4e22-a989-9271e02b009b	cb584f41-6a53-4a30-adf3-b76975d5f0ff	algorithm	HS256
004c1fbe-151c-4b14-a97f-60f21d46fe4d	cb584f41-6a53-4a30-adf3-b76975d5f0ff	secret	93iv7JOl5RhFSa8BhL3QwGF8TMLtfbTLmxowAv9TKmImk7O4KCxR1YY00oC2epGfrayOCPcZBwQUflE1eKoE3Q
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.composite_role (composite, child_role) FROM stdin;
b007d3b7-4ea5-45c2-9fa0-9661849d002b	1b265740-6ff1-4da3-8df8-3c50559ff5d2
b007d3b7-4ea5-45c2-9fa0-9661849d002b	bad23837-fd1f-44e1-a71b-da5e6980a925
b007d3b7-4ea5-45c2-9fa0-9661849d002b	5ef527ff-668c-4d54-83ec-046d9fd96998
b007d3b7-4ea5-45c2-9fa0-9661849d002b	e4f25d89-3c4c-4360-b13a-62bf48f2f11d
b007d3b7-4ea5-45c2-9fa0-9661849d002b	308eb029-1acd-46cc-a082-415be48f3e4e
b007d3b7-4ea5-45c2-9fa0-9661849d002b	e83a72eb-7f98-409f-ae1e-7b5779a479a1
b007d3b7-4ea5-45c2-9fa0-9661849d002b	c38a307e-83de-4249-bc83-a272e8a7a988
b007d3b7-4ea5-45c2-9fa0-9661849d002b	2e020aad-b166-4019-a11e-5a2b29342b6a
b007d3b7-4ea5-45c2-9fa0-9661849d002b	a871d833-7ab9-40b1-b474-131d00e57afc
b007d3b7-4ea5-45c2-9fa0-9661849d002b	ab837062-171e-4873-8d02-f63041a49d97
b007d3b7-4ea5-45c2-9fa0-9661849d002b	24c06798-b398-40fd-8101-ace1c23ba9b0
b007d3b7-4ea5-45c2-9fa0-9661849d002b	77dc9f6f-7a0b-4b00-9df2-5cd340b3f61a
b007d3b7-4ea5-45c2-9fa0-9661849d002b	b0b184a1-fd87-46ca-8d9f-97cadb06a240
b007d3b7-4ea5-45c2-9fa0-9661849d002b	808cb82e-b59d-4527-bcde-08686c250102
b007d3b7-4ea5-45c2-9fa0-9661849d002b	a3ca3d56-9aad-4939-8f51-e2dc28967e6c
b007d3b7-4ea5-45c2-9fa0-9661849d002b	30f6ce99-6dca-45b3-b348-00a44a342aec
b007d3b7-4ea5-45c2-9fa0-9661849d002b	a6b3a350-7a66-40a8-895d-21c792240c50
b007d3b7-4ea5-45c2-9fa0-9661849d002b	c06ec9c0-b12d-4c80-9b92-3397fb59d292
308eb029-1acd-46cc-a082-415be48f3e4e	30f6ce99-6dca-45b3-b348-00a44a342aec
e4f25d89-3c4c-4360-b13a-62bf48f2f11d	a3ca3d56-9aad-4939-8f51-e2dc28967e6c
e4f25d89-3c4c-4360-b13a-62bf48f2f11d	c06ec9c0-b12d-4c80-9b92-3397fb59d292
2e0d0160-b116-46e6-85c9-052f5b6f5e94	521f9ed2-5b01-465f-88f4-6e248e1aeee6
16bc9720-f076-4849-9089-f123d4da6146	e0c33b3a-a696-4fff-9829-b7a4846d7185
b007d3b7-4ea5-45c2-9fa0-9661849d002b	59f94b06-1fdd-4d34-aea8-a3fd9242e688
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
1fb8d6b2-e3b3-45e0-8a80-2239ed1e1498	\N	password	1935f31b-0183-4541-a014-165e34fc2c15	1619051408181	\N	{"value":"CSDbi76ERuphPnvog8GQyQ9BaJx1kcpzhRZkD6ewaisk4bnf4n3X74UTs79EAn7fDVfkGw2IoF4BpEdZf4Iexw==","salt":"VNQb2K83Txvq+hIt8LVCzA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2021-04-22 00:30:01.64596	1	EXECUTED	7:4e70412f24a3f382c82183742ec79317	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	9051400918
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2021-04-22 00:30:01.674729	2	MARK_RAN	7:cb16724583e9675711801c6875114f28	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	9051400918
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2021-04-22 00:30:01.75184	3	EXECUTED	7:0310eb8ba07cec616460794d42ade0fa	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	3.5.4	\N	\N	9051400918
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2021-04-22 00:30:01.75992	4	EXECUTED	7:5d25857e708c3233ef4439df1f93f012	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	9051400918
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2021-04-22 00:30:01.950416	5	EXECUTED	7:c7a54a1041d58eb3817a4a883b4d4e84	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	9051400918
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2021-04-22 00:30:01.956659	6	MARK_RAN	7:2e01012df20974c1c2a605ef8afe25b7	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	9051400918
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2021-04-22 00:30:02.164633	7	EXECUTED	7:0f08df48468428e0f30ee59a8ec01a41	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	9051400918
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2021-04-22 00:30:02.18712	8	MARK_RAN	7:a77ea2ad226b345e7d689d366f185c8c	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	9051400918
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2021-04-22 00:30:02.214736	9	EXECUTED	7:a3377a2059aefbf3b90ebb4c4cc8e2ab	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	3.5.4	\N	\N	9051400918
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2021-04-22 00:30:02.457752	10	EXECUTED	7:04c1dbedc2aa3e9756d1a1668e003451	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	3.5.4	\N	\N	9051400918
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2021-04-22 00:30:02.560672	11	EXECUTED	7:36ef39ed560ad07062d956db861042ba	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	9051400918
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2021-04-22 00:30:02.566746	12	MARK_RAN	7:d909180b2530479a716d3f9c9eaea3d7	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	9051400918
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2021-04-22 00:30:02.606764	13	EXECUTED	7:cf12b04b79bea5152f165eb41f3955f6	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	9051400918
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-04-22 00:30:02.699214	14	EXECUTED	7:7e32c8f05c755e8675764e7d5f514509	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	3.5.4	\N	\N	9051400918
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-04-22 00:30:02.706929	15	MARK_RAN	7:980ba23cc0ec39cab731ce903dd01291	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	9051400918
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-04-22 00:30:02.712556	16	MARK_RAN	7:2fa220758991285312eb84f3b4ff5336	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	3.5.4	\N	\N	9051400918
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-04-22 00:30:02.716514	17	EXECUTED	7:d41d8cd98f00b204e9800998ecf8427e	empty		\N	3.5.4	\N	\N	9051400918
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2021-04-22 00:30:02.802723	18	EXECUTED	7:91ace540896df890cc00a0490ee52bbc	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	3.5.4	\N	\N	9051400918
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2021-04-22 00:30:02.911091	19	EXECUTED	7:c31d1646dfa2618a9335c00e07f89f24	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	9051400918
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2021-04-22 00:30:02.921187	20	EXECUTED	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	9051400918
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-04-22 00:30:04.501964	45	EXECUTED	7:6a48ce645a3525488a90fbf76adf3bb3	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	9051400918
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2021-04-22 00:30:02.934329	21	MARK_RAN	7:f987971fe6b37d963bc95fee2b27f8df	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	9051400918
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2021-04-22 00:30:02.942628	22	MARK_RAN	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	9051400918
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2021-04-22 00:30:02.980698	23	EXECUTED	7:ed2dc7f799d19ac452cbcda56c929e47	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	3.5.4	\N	\N	9051400918
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2021-04-22 00:30:02.996353	24	EXECUTED	7:80b5db88a5dda36ece5f235be8757615	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	9051400918
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2021-04-22 00:30:03.000019	25	MARK_RAN	7:1437310ed1305a9b93f8848f301726ce	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	9051400918
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2021-04-22 00:30:03.145594	26	EXECUTED	7:b82ffb34850fa0836be16deefc6a87c4	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	3.5.4	\N	\N	9051400918
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2021-04-22 00:30:03.334694	27	EXECUTED	7:9cc98082921330d8d9266decdd4bd658	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	3.5.4	\N	\N	9051400918
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2021-04-22 00:30:03.340956	28	EXECUTED	7:03d64aeed9cb52b969bd30a7ac0db57e	update tableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	9051400918
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2021-04-22 00:30:03.475273	29	EXECUTED	7:f1f9fd8710399d725b780f463c6b21cd	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	3.5.4	\N	\N	9051400918
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2021-04-22 00:30:03.505736	30	EXECUTED	7:53188c3eb1107546e6f765835705b6c1	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	3.5.4	\N	\N	9051400918
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2021-04-22 00:30:03.534633	31	EXECUTED	7:d6e6f3bc57a0c5586737d1351725d4d4	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	3.5.4	\N	\N	9051400918
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2021-04-22 00:30:03.545555	32	EXECUTED	7:454d604fbd755d9df3fd9c6329043aa5	customChange		\N	3.5.4	\N	\N	9051400918
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-04-22 00:30:03.555925	33	EXECUTED	7:57e98a3077e29caf562f7dbf80c72600	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	9051400918
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-04-22 00:30:03.5616	34	MARK_RAN	7:e4c7e8f2256210aee71ddc42f538b57a	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	9051400918
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-04-22 00:30:03.607493	35	EXECUTED	7:09a43c97e49bc626460480aa1379b522	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	9051400918
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2021-04-22 00:30:03.614858	36	EXECUTED	7:26bfc7c74fefa9126f2ce702fb775553	addColumn tableName=REALM		\N	3.5.4	\N	\N	9051400918
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-04-22 00:30:03.627314	37	EXECUTED	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	9051400918
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2021-04-22 00:30:03.65427	38	EXECUTED	7:37fc1781855ac5388c494f1442b3f717	addColumn tableName=FED_USER_CONSENT		\N	3.5.4	\N	\N	9051400918
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2021-04-22 00:30:03.660425	39	EXECUTED	7:13a27db0dae6049541136adad7261d27	addColumn tableName=IDENTITY_PROVIDER		\N	3.5.4	\N	\N	9051400918
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-04-22 00:30:03.663745	40	MARK_RAN	7:550300617e3b59e8af3a6294df8248a3	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	9051400918
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-04-22 00:30:03.669532	41	MARK_RAN	7:e3a9482b8931481dc2772a5c07c44f17	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	9051400918
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2021-04-22 00:30:03.679585	42	EXECUTED	7:72b07d85a2677cb257edb02b408f332d	customChange		\N	3.5.4	\N	\N	9051400918
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-04-22 00:30:04.463398	43	EXECUTED	7:a72a7858967bd414835d19e04d880312	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	3.5.4	\N	\N	9051400918
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2021-04-22 00:30:04.492638	44	EXECUTED	7:94edff7cf9ce179e7e85f0cd78a3cf2c	addColumn tableName=USER_ENTITY		\N	3.5.4	\N	\N	9051400918
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-04-22 00:30:04.509605	46	EXECUTED	7:e64b5dcea7db06077c6e57d3b9e5ca14	customChange		\N	3.5.4	\N	\N	9051400918
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-04-22 00:30:04.512105	47	MARK_RAN	7:fd8cf02498f8b1e72496a20afc75178c	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	9051400918
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-04-22 00:30:04.570238	48	EXECUTED	7:542794f25aa2b1fbabb7e577d6646319	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	3.5.4	\N	\N	9051400918
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-04-22 00:30:04.578495	49	EXECUTED	7:edad604c882df12f74941dac3cc6d650	addColumn tableName=REALM		\N	3.5.4	\N	\N	9051400918
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2021-04-22 00:30:04.671899	50	EXECUTED	7:0f88b78b7b46480eb92690cbf5e44900	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	3.5.4	\N	\N	9051400918
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2021-04-22 00:30:04.733936	51	EXECUTED	7:d560e43982611d936457c327f872dd59	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	3.5.4	\N	\N	9051400918
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2021-04-22 00:30:04.738102	52	EXECUTED	7:c155566c42b4d14ef07059ec3b3bbd8e	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	9051400918
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2021-04-22 00:30:04.741904	53	EXECUTED	7:b40376581f12d70f3c89ba8ddf5b7dea	update tableName=REALM		\N	3.5.4	\N	\N	9051400918
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2021-04-22 00:30:04.750262	54	EXECUTED	7:a1132cc395f7b95b3646146c2e38f168	update tableName=CLIENT		\N	3.5.4	\N	\N	9051400918
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-04-22 00:30:04.759221	55	EXECUTED	7:d8dc5d89c789105cfa7ca0e82cba60af	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	3.5.4	\N	\N	9051400918
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-04-22 00:30:04.766641	56	EXECUTED	7:7822e0165097182e8f653c35517656a3	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	3.5.4	\N	\N	9051400918
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-04-22 00:30:04.798865	57	EXECUTED	7:c6538c29b9c9a08f9e9ea2de5c2b6375	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	3.5.4	\N	\N	9051400918
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-04-22 00:30:04.932674	58	EXECUTED	7:6d4893e36de22369cf73bcb051ded875	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	3.5.4	\N	\N	9051400918
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2021-04-22 00:30:04.966852	59	EXECUTED	7:57960fc0b0f0dd0563ea6f8b2e4a1707	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	3.5.4	\N	\N	9051400918
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2021-04-22 00:30:04.972982	60	EXECUTED	7:2b4b8bff39944c7097977cc18dbceb3b	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	9051400918
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-04-22 00:30:04.981814	61	EXECUTED	7:2aa42a964c59cd5b8ca9822340ba33a8	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	3.5.4	\N	\N	9051400918
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-04-22 00:30:04.989524	62	EXECUTED	7:9ac9e58545479929ba23f4a3087a0346	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	3.5.4	\N	\N	9051400918
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2021-04-22 00:30:04.994507	63	EXECUTED	7:14d407c35bc4fe1976867756bcea0c36	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	9051400918
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2021-04-22 00:30:04.997922	64	EXECUTED	7:241a8030c748c8548e346adee548fa93	update tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	9051400918
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2021-04-22 00:30:05.000829	65	EXECUTED	7:7d3182f65a34fcc61e8d23def037dc3f	update tableName=RESOURCE_SERVER_RESOURCE		\N	3.5.4	\N	\N	9051400918
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2021-04-22 00:30:05.014371	66	EXECUTED	7:b30039e00a0b9715d430d1b0636728fa	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	3.5.4	\N	\N	9051400918
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2021-04-22 00:30:05.023969	67	EXECUTED	7:3797315ca61d531780f8e6f82f258159	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	3.5.4	\N	\N	9051400918
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2021-04-22 00:30:05.05156	68	EXECUTED	7:c7aa4c8d9573500c2d347c1941ff0301	addColumn tableName=REALM		\N	3.5.4	\N	\N	9051400918
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2021-04-22 00:30:05.063258	69	EXECUTED	7:b207faee394fc074a442ecd42185a5dd	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	3.5.4	\N	\N	9051400918
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2021-04-22 00:30:05.070006	70	EXECUTED	7:ab9a9762faaba4ddfa35514b212c4922	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	3.5.4	\N	\N	9051400918
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2021-04-22 00:30:05.077518	71	EXECUTED	7:b9710f74515a6ccb51b72dc0d19df8c4	addColumn tableName=RESOURCE_SERVER		\N	3.5.4	\N	\N	9051400918
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-04-22 00:30:05.08425	72	EXECUTED	7:ec9707ae4d4f0b7452fee20128083879	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	9051400918
8.0.0-updating-credential-data-not-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-04-22 00:30:05.106587	73	EXECUTED	7:03b3f4b264c3c68ba082250a80b74216	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	9051400918
8.0.0-updating-credential-data-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-04-22 00:30:05.109389	74	MARK_RAN	7:64c5728f5ca1f5aa4392217701c4fe23	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	9051400918
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-04-22 00:30:05.127359	75	EXECUTED	7:b48da8c11a3d83ddd6b7d0c8c2219345	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	3.5.4	\N	\N	9051400918
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-04-22 00:30:05.135486	76	EXECUTED	7:a73379915c23bfad3e8f5c6d5c0aa4bd	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	3.5.4	\N	\N	9051400918
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-04-22 00:30:05.139372	77	EXECUTED	7:39e0073779aba192646291aa2332493d	addColumn tableName=CLIENT		\N	3.5.4	\N	\N	9051400918
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-04-22 00:30:05.141942	78	MARK_RAN	7:81f87368f00450799b4bf42ea0b3ec34	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	3.5.4	\N	\N	9051400918
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-04-22 00:30:05.163285	79	EXECUTED	7:20b37422abb9fb6571c618148f013a15	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	3.5.4	\N	\N	9051400918
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-04-22 00:30:05.172664	80	MARK_RAN	7:1970bb6cfb5ee800736b95ad3fb3c78a	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	3.5.4	\N	\N	9051400918
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-04-22 00:30:05.18744	81	EXECUTED	7:45d9b25fc3b455d522d8dcc10a0f4c80	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	3.5.4	\N	\N	9051400918
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-04-22 00:30:05.190225	82	MARK_RAN	7:890ae73712bc187a66c2813a724d037f	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	9051400918
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-04-22 00:30:05.194699	83	EXECUTED	7:0a211980d27fafe3ff50d19a3a29b538	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	9051400918
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-04-22 00:30:05.19762	84	MARK_RAN	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	9051400918
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-04-22 00:30:05.206611	85	EXECUTED	7:01c49302201bdf815b0a18d1f98a55dc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	9051400918
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2021-04-22 00:30:05.212158	86	EXECUTED	7:3dace6b144c11f53f1ad2c0361279b86	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	3.5.4	\N	\N	9051400918
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-04-22 00:30:05.220752	87	EXECUTED	7:578d0b92077eaf2ab95ad0ec087aa903	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	3.5.4	\N	\N	9051400918
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-04-22 00:30:05.249963	88	EXECUTED	7:c95abe90d962c57a09ecaee57972835d	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	3.5.4	\N	\N	9051400918
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
master	c6981dfc-1a4f-4353-8119-e3e070bc395d	f
master	d6615c6a-c16e-445e-996e-bd4cf2de6f24	t
master	51e68398-b458-4dbf-bfa0-ccdee7686819	t
master	27a31baf-b429-4901-91ef-ad61320b82b6	t
master	b5cc522e-37d2-4a87-bb2b-208bbf962cd9	f
master	40c8a2e2-0da4-4375-bb5e-2465b859b356	f
master	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923	t
master	d03ebe06-a975-4861-96b0-0c5f10e6332c	t
master	e56ca7dc-1026-4f43-a944-ded83541ae1b	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
1b265740-6ff1-4da3-8df8-3c50559ff5d2	master	f	${role_create-realm}	create-realm	master	\N	master
b007d3b7-4ea5-45c2-9fa0-9661849d002b	master	f	${role_admin}	admin	master	\N	master
bad23837-fd1f-44e1-a71b-da5e6980a925	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_create-client}	create-client	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
5ef527ff-668c-4d54-83ec-046d9fd96998	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-realm}	view-realm	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
e4f25d89-3c4c-4360-b13a-62bf48f2f11d	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-users}	view-users	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
308eb029-1acd-46cc-a082-415be48f3e4e	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-clients}	view-clients	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
e83a72eb-7f98-409f-ae1e-7b5779a479a1	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-events}	view-events	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
c38a307e-83de-4249-bc83-a272e8a7a988	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-identity-providers}	view-identity-providers	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
2e020aad-b166-4019-a11e-5a2b29342b6a	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_view-authorization}	view-authorization	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
a871d833-7ab9-40b1-b474-131d00e57afc	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-realm}	manage-realm	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
ab837062-171e-4873-8d02-f63041a49d97	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-users}	manage-users	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
24c06798-b398-40fd-8101-ace1c23ba9b0	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-clients}	manage-clients	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
77dc9f6f-7a0b-4b00-9df2-5cd340b3f61a	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-events}	manage-events	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
b0b184a1-fd87-46ca-8d9f-97cadb06a240	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-identity-providers}	manage-identity-providers	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
808cb82e-b59d-4527-bcde-08686c250102	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_manage-authorization}	manage-authorization	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
a3ca3d56-9aad-4939-8f51-e2dc28967e6c	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_query-users}	query-users	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
30f6ce99-6dca-45b3-b348-00a44a342aec	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_query-clients}	query-clients	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
a6b3a350-7a66-40a8-895d-21c792240c50	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_query-realms}	query-realms	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
c06ec9c0-b12d-4c80-9b92-3397fb59d292	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_query-groups}	query-groups	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
996dcece-84da-499f-b608-5fa354980970	06185161-1d64-445f-99af-b865b67b5324	t	${role_view-profile}	view-profile	master	06185161-1d64-445f-99af-b865b67b5324	\N
2e0d0160-b116-46e6-85c9-052f5b6f5e94	06185161-1d64-445f-99af-b865b67b5324	t	${role_manage-account}	manage-account	master	06185161-1d64-445f-99af-b865b67b5324	\N
521f9ed2-5b01-465f-88f4-6e248e1aeee6	06185161-1d64-445f-99af-b865b67b5324	t	${role_manage-account-links}	manage-account-links	master	06185161-1d64-445f-99af-b865b67b5324	\N
d3548849-ab6e-45c3-86e4-540ba0528198	06185161-1d64-445f-99af-b865b67b5324	t	${role_view-applications}	view-applications	master	06185161-1d64-445f-99af-b865b67b5324	\N
e0c33b3a-a696-4fff-9829-b7a4846d7185	06185161-1d64-445f-99af-b865b67b5324	t	${role_view-consent}	view-consent	master	06185161-1d64-445f-99af-b865b67b5324	\N
16bc9720-f076-4849-9089-f123d4da6146	06185161-1d64-445f-99af-b865b67b5324	t	${role_manage-consent}	manage-consent	master	06185161-1d64-445f-99af-b865b67b5324	\N
fdcabf4c-f828-4613-8862-2c57c69ca86b	06185161-1d64-445f-99af-b865b67b5324	t	${role_delete-account}	delete-account	master	06185161-1d64-445f-99af-b865b67b5324	\N
a4e5fd97-3c7a-4fa2-85e7-14df67732c57	4d920f2c-4610-47fb-a5de-cb141bd936cc	t	${role_read-token}	read-token	master	4d920f2c-4610-47fb-a5de-cb141bd936cc	\N
59f94b06-1fdd-4d34-aea8-a3fd9242e688	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	t	${role_impersonation}	impersonation	master	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	\N
1eb72a08-fd92-49ea-9834-ebd8f1c35283	master	f	${role_offline-access}	offline_access	master	\N	master
a60f2a84-99d5-4f58-98ca-c016f4097d3a	master	f	${role_uma_authorization}	uma_authorization	master	\N	master
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.migration_model (id, version, update_time) FROM stdin;
cw0bc	12.0.4	1619051405
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
73e160a2-1a84-4c77-83b6-1897c578d603	audience resolve	openid-connect	oidc-audience-resolve-mapper	88d979f1-af0a-478d-a837-04a70e9fdef9	\N
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	locale	openid-connect	oidc-usermodel-attribute-mapper	48b528c7-f14b-4582-b97e-56dd9ba87105	\N
6e9d220c-c3b0-477e-9f9e-bbe66b883437	role list	saml	saml-role-list-mapper	\N	d6615c6a-c16e-445e-996e-bd4cf2de6f24
2e29a756-17a7-44ef-8878-bf83653a6c6a	full name	openid-connect	oidc-full-name-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	family name	openid-connect	oidc-usermodel-property-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	given name	openid-connect	oidc-usermodel-property-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
efda7f02-9f0b-4068-bb35-911e22743bfa	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
b77b22dd-2845-4087-b848-4136492fe085	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	username	openid-connect	oidc-usermodel-property-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
304eb7de-0294-4e0a-947d-1e1357cb7bd5	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
bbb888b8-a02e-4956-924f-a677f94da25a	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
086cdf40-beb6-4752-8fc7-255656d035fc	website	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
0324a06b-624b-468a-a50f-50d410ab181a	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
43933ebe-3c6e-4af1-bd08-6041ff2f4436	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
b0471944-6ac9-49dd-b9ee-cba06dbea883	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
0377cacb-b513-40b2-92a7-640a8eb9d1b2	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	51e68398-b458-4dbf-bfa0-ccdee7686819
d6a9862e-b853-4c2a-84e0-d29059536252	email	openid-connect	oidc-usermodel-property-mapper	\N	27a31baf-b429-4901-91ef-ad61320b82b6
176fc201-6fe4-4c42-a712-2d3e6489c50e	email verified	openid-connect	oidc-usermodel-property-mapper	\N	27a31baf-b429-4901-91ef-ad61320b82b6
978a2669-8336-4f9d-9e30-e51635cd4736	address	openid-connect	oidc-address-mapper	\N	b5cc522e-37d2-4a87-bb2b-208bbf962cd9
5dafb33e-0130-463f-a141-8d37f7e9321d	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	40c8a2e2-0da4-4375-bb5e-2465b859b356
43509fd5-239a-4e39-a8fe-7e2b214fbf33	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	40c8a2e2-0da4-4375-bb5e-2465b859b356
f5794da1-4c84-4963-aaf5-ccb8d13fc412	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923
f3d64a1e-20ff-434a-8015-7d427dc00283	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923
6f40a4d3-4c45-4ec6-9afc-1a1eb8ca9bc2	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	f3a2fe0e-6e07-4be9-a270-dc3ccc93b923
ebe1389d-c050-4695-88e2-ce4d637900c3	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	d03ebe06-a975-4861-96b0-0c5f10e6332c
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	upn	openid-connect	oidc-usermodel-property-mapper	\N	e56ca7dc-1026-4f43-a944-ded83541ae1b
bba94c88-b35f-42b9-9b91-68195678e48a	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	e56ca7dc-1026-4f43-a944-ded83541ae1b
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	true	userinfo.token.claim
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	locale	user.attribute
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	true	id.token.claim
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	true	access.token.claim
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	locale	claim.name
cb57f1af-635e-4c0b-9b7e-6af732bbab1c	String	jsonType.label
6e9d220c-c3b0-477e-9f9e-bbe66b883437	false	single
6e9d220c-c3b0-477e-9f9e-bbe66b883437	Basic	attribute.nameformat
6e9d220c-c3b0-477e-9f9e-bbe66b883437	Role	attribute.name
0324a06b-624b-468a-a50f-50d410ab181a	true	userinfo.token.claim
0324a06b-624b-468a-a50f-50d410ab181a	gender	user.attribute
0324a06b-624b-468a-a50f-50d410ab181a	true	id.token.claim
0324a06b-624b-468a-a50f-50d410ab181a	true	access.token.claim
0324a06b-624b-468a-a50f-50d410ab181a	gender	claim.name
0324a06b-624b-468a-a50f-50d410ab181a	String	jsonType.label
0377cacb-b513-40b2-92a7-640a8eb9d1b2	true	userinfo.token.claim
0377cacb-b513-40b2-92a7-640a8eb9d1b2	updatedAt	user.attribute
0377cacb-b513-40b2-92a7-640a8eb9d1b2	true	id.token.claim
0377cacb-b513-40b2-92a7-640a8eb9d1b2	true	access.token.claim
0377cacb-b513-40b2-92a7-640a8eb9d1b2	updated_at	claim.name
0377cacb-b513-40b2-92a7-640a8eb9d1b2	String	jsonType.label
086cdf40-beb6-4752-8fc7-255656d035fc	true	userinfo.token.claim
086cdf40-beb6-4752-8fc7-255656d035fc	website	user.attribute
086cdf40-beb6-4752-8fc7-255656d035fc	true	id.token.claim
086cdf40-beb6-4752-8fc7-255656d035fc	true	access.token.claim
086cdf40-beb6-4752-8fc7-255656d035fc	website	claim.name
086cdf40-beb6-4752-8fc7-255656d035fc	String	jsonType.label
2e29a756-17a7-44ef-8878-bf83653a6c6a	true	userinfo.token.claim
2e29a756-17a7-44ef-8878-bf83653a6c6a	true	id.token.claim
2e29a756-17a7-44ef-8878-bf83653a6c6a	true	access.token.claim
304eb7de-0294-4e0a-947d-1e1357cb7bd5	true	userinfo.token.claim
304eb7de-0294-4e0a-947d-1e1357cb7bd5	profile	user.attribute
304eb7de-0294-4e0a-947d-1e1357cb7bd5	true	id.token.claim
304eb7de-0294-4e0a-947d-1e1357cb7bd5	true	access.token.claim
304eb7de-0294-4e0a-947d-1e1357cb7bd5	profile	claim.name
304eb7de-0294-4e0a-947d-1e1357cb7bd5	String	jsonType.label
43933ebe-3c6e-4af1-bd08-6041ff2f4436	true	userinfo.token.claim
43933ebe-3c6e-4af1-bd08-6041ff2f4436	birthdate	user.attribute
43933ebe-3c6e-4af1-bd08-6041ff2f4436	true	id.token.claim
43933ebe-3c6e-4af1-bd08-6041ff2f4436	true	access.token.claim
43933ebe-3c6e-4af1-bd08-6041ff2f4436	birthdate	claim.name
43933ebe-3c6e-4af1-bd08-6041ff2f4436	String	jsonType.label
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	true	userinfo.token.claim
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	username	user.attribute
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	true	id.token.claim
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	true	access.token.claim
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	preferred_username	claim.name
7d2d3243-42ca-4e92-b2ef-817cdc9710aa	String	jsonType.label
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	true	userinfo.token.claim
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	firstName	user.attribute
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	true	id.token.claim
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	true	access.token.claim
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	given_name	claim.name
7d7fdcc1-661a-4f6f-873b-8f24cc92d7a3	String	jsonType.label
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	true	userinfo.token.claim
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	lastName	user.attribute
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	true	id.token.claim
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	true	access.token.claim
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	family_name	claim.name
7e9f3249-3e4a-4cb1-9cc9-f901fc3c1318	String	jsonType.label
b0471944-6ac9-49dd-b9ee-cba06dbea883	true	userinfo.token.claim
b0471944-6ac9-49dd-b9ee-cba06dbea883	zoneinfo	user.attribute
b0471944-6ac9-49dd-b9ee-cba06dbea883	true	id.token.claim
b0471944-6ac9-49dd-b9ee-cba06dbea883	true	access.token.claim
b0471944-6ac9-49dd-b9ee-cba06dbea883	zoneinfo	claim.name
b0471944-6ac9-49dd-b9ee-cba06dbea883	String	jsonType.label
b77b22dd-2845-4087-b848-4136492fe085	true	userinfo.token.claim
b77b22dd-2845-4087-b848-4136492fe085	nickname	user.attribute
b77b22dd-2845-4087-b848-4136492fe085	true	id.token.claim
b77b22dd-2845-4087-b848-4136492fe085	true	access.token.claim
b77b22dd-2845-4087-b848-4136492fe085	nickname	claim.name
b77b22dd-2845-4087-b848-4136492fe085	String	jsonType.label
bbb888b8-a02e-4956-924f-a677f94da25a	true	userinfo.token.claim
bbb888b8-a02e-4956-924f-a677f94da25a	picture	user.attribute
bbb888b8-a02e-4956-924f-a677f94da25a	true	id.token.claim
bbb888b8-a02e-4956-924f-a677f94da25a	true	access.token.claim
bbb888b8-a02e-4956-924f-a677f94da25a	picture	claim.name
bbb888b8-a02e-4956-924f-a677f94da25a	String	jsonType.label
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	true	userinfo.token.claim
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	locale	user.attribute
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	true	id.token.claim
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	true	access.token.claim
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	locale	claim.name
bfe11c51-8cf3-4c72-a5e7-4a31d89057c9	String	jsonType.label
efda7f02-9f0b-4068-bb35-911e22743bfa	true	userinfo.token.claim
efda7f02-9f0b-4068-bb35-911e22743bfa	middleName	user.attribute
efda7f02-9f0b-4068-bb35-911e22743bfa	true	id.token.claim
efda7f02-9f0b-4068-bb35-911e22743bfa	true	access.token.claim
efda7f02-9f0b-4068-bb35-911e22743bfa	middle_name	claim.name
efda7f02-9f0b-4068-bb35-911e22743bfa	String	jsonType.label
176fc201-6fe4-4c42-a712-2d3e6489c50e	true	userinfo.token.claim
176fc201-6fe4-4c42-a712-2d3e6489c50e	emailVerified	user.attribute
176fc201-6fe4-4c42-a712-2d3e6489c50e	true	id.token.claim
176fc201-6fe4-4c42-a712-2d3e6489c50e	true	access.token.claim
176fc201-6fe4-4c42-a712-2d3e6489c50e	email_verified	claim.name
176fc201-6fe4-4c42-a712-2d3e6489c50e	boolean	jsonType.label
d6a9862e-b853-4c2a-84e0-d29059536252	true	userinfo.token.claim
d6a9862e-b853-4c2a-84e0-d29059536252	email	user.attribute
d6a9862e-b853-4c2a-84e0-d29059536252	true	id.token.claim
d6a9862e-b853-4c2a-84e0-d29059536252	true	access.token.claim
d6a9862e-b853-4c2a-84e0-d29059536252	email	claim.name
d6a9862e-b853-4c2a-84e0-d29059536252	String	jsonType.label
978a2669-8336-4f9d-9e30-e51635cd4736	formatted	user.attribute.formatted
978a2669-8336-4f9d-9e30-e51635cd4736	country	user.attribute.country
978a2669-8336-4f9d-9e30-e51635cd4736	postal_code	user.attribute.postal_code
978a2669-8336-4f9d-9e30-e51635cd4736	true	userinfo.token.claim
978a2669-8336-4f9d-9e30-e51635cd4736	street	user.attribute.street
978a2669-8336-4f9d-9e30-e51635cd4736	true	id.token.claim
978a2669-8336-4f9d-9e30-e51635cd4736	region	user.attribute.region
978a2669-8336-4f9d-9e30-e51635cd4736	true	access.token.claim
978a2669-8336-4f9d-9e30-e51635cd4736	locality	user.attribute.locality
43509fd5-239a-4e39-a8fe-7e2b214fbf33	true	userinfo.token.claim
43509fd5-239a-4e39-a8fe-7e2b214fbf33	phoneNumberVerified	user.attribute
43509fd5-239a-4e39-a8fe-7e2b214fbf33	true	id.token.claim
43509fd5-239a-4e39-a8fe-7e2b214fbf33	true	access.token.claim
43509fd5-239a-4e39-a8fe-7e2b214fbf33	phone_number_verified	claim.name
43509fd5-239a-4e39-a8fe-7e2b214fbf33	boolean	jsonType.label
5dafb33e-0130-463f-a141-8d37f7e9321d	true	userinfo.token.claim
5dafb33e-0130-463f-a141-8d37f7e9321d	phoneNumber	user.attribute
5dafb33e-0130-463f-a141-8d37f7e9321d	true	id.token.claim
5dafb33e-0130-463f-a141-8d37f7e9321d	true	access.token.claim
5dafb33e-0130-463f-a141-8d37f7e9321d	phone_number	claim.name
5dafb33e-0130-463f-a141-8d37f7e9321d	String	jsonType.label
f3d64a1e-20ff-434a-8015-7d427dc00283	true	multivalued
f3d64a1e-20ff-434a-8015-7d427dc00283	foo	user.attribute
f3d64a1e-20ff-434a-8015-7d427dc00283	true	access.token.claim
f3d64a1e-20ff-434a-8015-7d427dc00283	resource_access.${client_id}.roles	claim.name
f3d64a1e-20ff-434a-8015-7d427dc00283	String	jsonType.label
f5794da1-4c84-4963-aaf5-ccb8d13fc412	true	multivalued
f5794da1-4c84-4963-aaf5-ccb8d13fc412	foo	user.attribute
f5794da1-4c84-4963-aaf5-ccb8d13fc412	true	access.token.claim
f5794da1-4c84-4963-aaf5-ccb8d13fc412	realm_access.roles	claim.name
f5794da1-4c84-4963-aaf5-ccb8d13fc412	String	jsonType.label
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	true	userinfo.token.claim
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	username	user.attribute
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	true	id.token.claim
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	true	access.token.claim
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	upn	claim.name
4b34523c-f0bf-44b0-80f7-5ba57b9b1091	String	jsonType.label
bba94c88-b35f-42b9-9b91-68195678e48a	true	multivalued
bba94c88-b35f-42b9-9b91-68195678e48a	foo	user.attribute
bba94c88-b35f-42b9-9b91-68195678e48a	true	id.token.claim
bba94c88-b35f-42b9-9b91-68195678e48a	true	access.token.claim
bba94c88-b35f-42b9-9b91-68195678e48a	groups	claim.name
bba94c88-b35f-42b9-9b91-68195678e48a	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me) FROM stdin;
master	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	c1b0e41e-2bf1-4acd-91a2-3f64c3f8ef5c	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	0c2542f7-3d75-4d3b-abe6-05bc0a3b5056	1c49c324-ee1e-47f7-b062-b2f4b3955e98	d8fab0e5-ba30-4881-8db1-0fec00e65c78	400f0e71-8f1e-4843-a621-312c9d3477c8	7dc04757-7dcd-42f7-8b25-97df19bd497d	2592000	f	900	t	f	e612fbe0-36de-4b5c-b050-fdcb7504a5ee	0	f	0	0
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_attribute (name, value, realm_id) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly		master
_browser_header.xContentTypeOptions	nosniff	master
_browser_header.xRobotsTag	none	master
_browser_header.xFrameOptions	SAMEORIGIN	master
_browser_header.contentSecurityPolicy	frame-src 'self'; frame-ancestors 'self'; object-src 'none';	master
_browser_header.xXSSProtection	1; mode=block	master
_browser_header.strictTransportSecurity	max-age=31536000; includeSubDomains	master
bruteForceProtected	false	master
permanentLockout	false	master
maxFailureWaitSeconds	900	master
minimumQuickLoginWaitSeconds	60	master
waitIncrementSeconds	60	master
quickLoginCheckMilliSeconds	1000	master
maxDeltaTimeSeconds	43200	master
failureFactor	30	master
displayName	Keycloak	master
displayNameHtml	<div class="kc-logo-text"><span>Keycloak</span></div>	master
offlineSessionMaxLifespanEnabled	false	master
offlineSessionMaxLifespan	5184000	master
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_default_roles; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_default_roles (realm_id, role_id) FROM stdin;
master	1eb72a08-fd92-49ea-9834-ebd8f1c35283
master	a60f2a84-99d5-4f58-98ca-c016f4097d3a
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
master	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	master
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.redirect_uris (client_id, value) FROM stdin;
06185161-1d64-445f-99af-b865b67b5324	/realms/master/account/*
88d979f1-af0a-478d-a837-04a70e9fdef9	/realms/master/account/*
48b528c7-f14b-4582-b97e-56dd9ba87105	/admin/master/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
3d2a4558-b297-4d72-b355-5a0b0b8844a0	VERIFY_EMAIL	Verify Email	master	t	f	VERIFY_EMAIL	50
129854f5-c846-4129-92ba-ef93c26d3ffd	UPDATE_PROFILE	Update Profile	master	t	f	UPDATE_PROFILE	40
d55a87df-6de8-4f76-bcbf-7422baec47ab	CONFIGURE_TOTP	Configure OTP	master	t	f	CONFIGURE_TOTP	10
4e726cf1-cc86-4ae8-85a2-a2f763395359	UPDATE_PASSWORD	Update Password	master	t	f	UPDATE_PASSWORD	30
c24b95d0-993c-4c81-b560-3b494c3871d9	terms_and_conditions	Terms and Conditions	master	f	f	terms_and_conditions	20
df34049f-2814-4862-895a-390d0e15e21f	update_user_locale	Update User Locale	master	t	f	update_user_locale	1000
7e5a6e57-2a0f-4ebd-9dfa-c57689f81816	delete_account	Delete Account	master	f	f	delete_account	60
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
88d979f1-af0a-478d-a837-04a70e9fdef9	2e0d0160-b116-46e6-85c9-052f5b6f5e94
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
1935f31b-0183-4541-a014-165e34fc2c15	\N	d6170b14-4b0a-4aa5-b711-a6a8f407adfa	f	t	\N	\N	\N	master	admin	1619051407522	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
a60f2a84-99d5-4f58-98ca-c016f4097d3a	1935f31b-0183-4541-a014-165e34fc2c15
1eb72a08-fd92-49ea-9834-ebd8f1c35283	1935f31b-0183-4541-a014-165e34fc2c15
996dcece-84da-499f-b608-5fa354980970	1935f31b-0183-4541-a014-165e34fc2c15
2e0d0160-b116-46e6-85c9-052f5b6f5e94	1935f31b-0183-4541-a014-165e34fc2c15
b007d3b7-4ea5-45c2-9fa0-9661849d002b	1935f31b-0183-4541-a014-165e34fc2c15
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.web_origins (client_id, value) FROM stdin;
48b528c7-f14b-4582-b97e-56dd9ba87105	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: client_default_roles constr_client_default_roles; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT constr_client_default_roles PRIMARY KEY (client_id, role_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: realm_default_roles constraint_realm_default_roles; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT constraint_realm_default_roles PRIMARY KEY (realm_id, role_id);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client_default_roles uk_8aelwnibji49avxsrtuf6xjow; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT uk_8aelwnibji49avxsrtuf6xjow UNIQUE (role_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: realm_default_roles uk_h4wpd7w4hsoolni3h0sw7btje; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT uk_h4wpd7w4hsoolni3h0sw7btje UNIQUE (role_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_def_roles_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_def_roles_client ON public.client_default_roles USING btree (client_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_def_roles_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_def_roles_realm ON public.realm_default_roles USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_client fk_c_cli_scope_client; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_client FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_scope_client fk_c_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_roles fk_evudb1ppw84oxfax2drs03icc; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT fk_evudb1ppw84oxfax2drs03icc FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_default_roles fk_nuilts7klwqw2h8m2b5joytky; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT fk_nuilts7klwqw2h8m2b5joytky FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client fk_p56ctinxxb9gsk57fo49f9tac; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT fk_p56ctinxxb9gsk57fo49f9tac FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope fk_realm_cli_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT fk_realm_cli_scope FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

