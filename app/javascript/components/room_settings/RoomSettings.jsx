import React from 'react';
import { Row, Button, Col } from 'react-bootstrap';
import { useParams } from 'react-router-dom';
import Card from 'react-bootstrap/Card';
import Spinner from '../shared/stylings/Spinner';
import useDeleteRoom from '../../hooks/mutations/rooms/useDeleteRoom';
import useRoomSettings from '../../hooks/queries/rooms/useRoomSettings';
import RoomSettingsRow from './RoomSettingsRow';
import useAccessCodes from '../../hooks/queries/rooms/useAccessCodes';
import useGenerateAccessCode from '../../hooks/mutations/rooms/useGenerateAccessCode';
import useDeleteAccessCode from '../../hooks/mutations/rooms/useDeleteAccessCode';

export default function RoomSettings() {
  const { friendlyId } = useParams();
  const { data: accessCodes } = useAccessCodes(friendlyId);
  const { isLoading, data: settings } = useRoomSettings(friendlyId);
  const { handleDeleteRoom, isLoading: deleteRoomIsLoading } = useDeleteRoom(friendlyId);
  const { handleGenerateAccessCode } = useGenerateAccessCode(friendlyId);
  const { handleDeleteAccessCode } = useDeleteAccessCode(friendlyId);

  if (isLoading) return <Spinner />;

  function checkedValue(settingId) {
    const { value } = settings.find((setting) => setting.name === settingId);

    if (value === 'true' || value === 'ASK_MODERATOR') {
      return true;
    } if (value === 'false' || value === 'ALWAYS_ACCEPT') {
      return false;
    }
    return value;
  }

  return (
    <div className="wide-background full-height-room">
      <Card className="mx-auto mt-3 p-4 border-0 shadow-sm">
        <div className="mt-2">
          <Row>
            <Col className="border-end border-2">
              <Row>
                <h6 className="text-primary">Room Name</h6>
              </Row>
              <Row>
                <h6 className="text-primary">Generate access code for viewers</h6>
                <div>
                  <Button
                    variant="primary-light"
                    onClick={() => handleGenerateAccessCode('Viewer')}
                  >
                    Generate
                  </Button>
                </div>
                {
                  accessCodes?.viewer_access_code
                }
                <div>
                  <Button
                    variant="danger"
                    onClick={() => handleDeleteAccessCode('Viewer')}
                  >
                    Remove
                  </Button>
                </div>
              </Row>
              <Row>
                <h6 className="text-primary">Generate access code for moderators</h6>
                <div>
                  <Button
                    variant="primary-light"
                    onClick={() => handleGenerateAccessCode('Moderator')}
                  >
                    Generate
                  </Button>
                </div>
                {
                  accessCodes?.moderator_access_code
                }
                <div>
                  <Button
                    variant="danger"
                    onClick={() => handleDeleteAccessCode('Moderator')}
                  >
                    Remove
                  </Button>
                </div>
              </Row>
            </Col>
            <Col className="ps-4">
              <h6 className="text-primary">User Settings</h6>
              <RoomSettingsRow
                settingId="muteOnStart"
                value={checkedValue('muteOnStart')}
                description="Mute users when they join"
              />
              <RoomSettingsRow
                settingId="guestPolicy"
                value={checkedValue('guestPolicy')}
                description="Require moderator approval before joining"
              />
              <RoomSettingsRow
                settingId="glAnyoneCanStart"
                value={checkedValue('glAnyoneCanStart')}
                description="Allow any user to start this meeting"
              />
              <RoomSettingsRow
                settingId="glAnyoneJoinAsModerator"
                value={checkedValue('glAnyoneJoinAsModerator')}
                description="All users join as moderators"
              />
              <RoomSettingsRow
                settingId="record"
                value={checkedValue('record')}
                description="Allow room to be recorded"
              />
            </Col>
          </Row>
          <Row className="float-end">
            <Button id="delete-room" className="mt-1 mx-2 float-end" onClick={handleDeleteRoom}>
              Delete Room
              {deleteRoomIsLoading && <Spinner />}
            </Button>
          </Row>
        </div>
      </Card>
    </div>
  );
}